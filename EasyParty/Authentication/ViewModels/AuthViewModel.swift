//
//  AuthViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Foundation
import GoogleSignIn
import GoogleSignInSwift

protocol AuthenticationFormProtocol {
  var formIsValid: Bool { get }
}

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

@MainActor
class AuthViewModel: ObservableObject {

  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: User?

  @Published var authError: AuthError?
  @Published var showAlert = false
  @Published var isLoading = false
  @Published var email = ""
  @Published var password = ""
  @Published var fullname = ""
  @Published var confirmPassword = ""
  @Published var showingEmailLogin = false

  @Published var newImageData: Data?

  @Published var authenticationState: AuthenticationState = .unauthenticated

  private var currentNonce: String?

  init() {
    registerAuthStateHandler()
    verifySignInWithAppleAuthenticationState()
    Task {
      await self.fetchUserData()
    }
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
        self?.userSession = user
        if user != nil {
          self?.authenticationState = .authenticated
          Task {
            await self?.fetchUserData()
          }
        } else {
          self?.authenticationState = .unauthenticated
          self?.currentUser = nil
        }
      }
    }
  }
}

// MARK: - Fetch user data

extension AuthViewModel {
  func fetchUserData() async {
    guard let uid = userSession?.uid else { return }

    do {
      let documentSnapshot = try await Firestore.firestore().collection("users").document(uid)
        .getDocument()
      let user = try documentSnapshot.data(as: User.self)
      DispatchQueue.main.async {
        self.currentUser = user
      }
    } catch {
      print("Erreur lors de la récupération des données utilisateur: \(error)")
    }
  }
}

// MARK: - Upload and update user
extension AuthViewModel {
  func saveProfileChanges() {
    guard let imageData = newImageData else { return }
    guard let image = UIImage(data: imageData) else {
      print("Error loading image")
      return
    }

    guard let compressedImageData = compressImage(image, maxSize: 1) else {  // Compresse à 1MB max
      print("Failed to compress image")
      return
    }

    guard let user = userSession else { return }
    let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")

    storageRef.putData(compressedImageData, metadata: nil) { [weak self] metadata, error in
      DispatchQueue.main.async {
        if let error = error {
          print("Failed to upload image: \(error.localizedDescription)")
          return
        }
        storageRef.downloadURL { (url, error) in
          guard let downloadURL = url else {
            print("Failed to get download URL")
            return
          }
          self?.updateUserProfile(imageUrl: downloadURL.absoluteString)
        }
      }
    }
  }

  func updateUserProfile(imageUrl: String) {
    guard let uid = userSession?.uid else { return }
    Firestore.firestore().collection("users").document(uid).updateData(["imageUrl": imageUrl]) {
      error in
      DispatchQueue.main.async {
        if let error = error {
          print("Error updating user profile: \(error.localizedDescription)")
        } else {
          self.currentUser?.imageUrl = imageUrl
        }
      }
    }
  }
}

// MARK: - Email and Password Authentication

extension AuthViewModel {


  func deleteUserData() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Firestore.firestore().collection("users").document(uid).delete { err in
      if let err = err {
        print("Erreur lors de la suppression des données utilisateur Firestore : \(err)")
      } else {
        print("Données utilisateur Firestore supprimées avec succès.")
      }
    }
  }

  func deleteAccount() async -> Bool {
    guard let user = userSession else { return false }
    guard let lastSignInDate = user.metadata.lastSignInDate else { return false }
    let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)

    let needsTokenRevocation = user.providerData.contains { $0.providerID == "apple.com" }
    deleteUserData()

    do {
      authenticationState = .authenticating
      if let imageUrl = currentUser?.imageUrl {
        let deletionResult = await withCheckedContinuation { continuation in
          FirestoreService().deleteImage(url: imageUrl) { error in
            if let error = error {
              print("Failed to delete image: \(error.localizedDescription)")
              continuation.resume(returning: false)
            } else {
              continuation.resume(returning: true)
            }
          }
        }

        if !deletionResult {
          print("Image deletion failed, aborting account deletion.")
          return false
        }
      }

      if needsReauth || needsTokenRevocation {
        let signInWithApple = SignInWithApple()
        let appleIDCredential = try await signInWithApple()

        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return false
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return false
        }

        let nonce = randomNonceString()
        let credential = OAuthProvider.credential(
          withProviderID: "apple.com",
          idToken: idTokenString,
          rawNonce: nonce)

        if needsReauth {
          try await user.reauthenticate(with: credential)
        }
        if needsTokenRevocation {
          guard let authorizationCode = appleIDCredential.authorizationCode else { return false }
          guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else {
            return false
          }

          try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
        }
      }

      try await user.delete()
      authenticationState = .unauthenticated
      return true
    } catch {
      print(error.localizedDescription)
      authenticationState = .authenticated
      return false
    }
  }

  func deleteAccountWithRevocationHelper() async -> Bool {
    do {

      try await TokenRevocationHelper().revokeToken()
      try await userSession?.delete()
      return true
    } catch {
      print(error.localizedDescription)
      return false
    }
  }

  func sendResetPasswordLink(toEmail email: String) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      if let error = error {
        print("DEBUG: Error sending password reset link : \(error.localizedDescription)")
      } else {
        print("DEBUG: Password reset link sent successfully")
      }
    }
  }
}

extension Date {
  func isWithinPast(minutes: Int) -> Bool {
    let now = Date.now
    let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
    let range = timeAgo...now
    return range.contains(self)
  }
}
