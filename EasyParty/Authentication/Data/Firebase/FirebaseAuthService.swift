//
//  FirebaseAuthService.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import CryptoKit
import AuthenticationServices

protocol FirebaseAuthService {
    func loginWithEmail(email: String, password: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func registerWithEmail(email: String, password: String, fullname: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func loginWithApple(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func resetPassword(toEmail email: String) async -> Result<Void, FirebaseAuthError>
    
    func signOut() throws
    
    func deleteAccount() async -> Result<Void, FirebaseAuthError>
    
}

struct DefaultFirebaseAuthService: FirebaseAuthService {
    func loginWithEmail(email: String, password: String) async -> Result<
        FirebaseUser, FirebaseAuthError > {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                let id = result.user.uid
                
                return await .success(try fetchUserData(id))
            } catch {
                let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
                return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
            }
        }
    
    func registerWithEmail(email: String, password: String, fullname: String) async -> Result<FirebaseUser, FirebaseAuthError> {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let id = result.user.uid
            
            try await setUserData(user: user)
            
            return await .success(try fetchUserData(id))
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    
    func loginWithApple(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<FirebaseUser, FirebaseAuthError> {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: token,
            rawNonce: nonce)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            let id = result.user.uid
            
            do {
                let user = try await fetchUserData(id)
                
                return .success(user)
            } catch {
                let formattedFullName = [givenName, familyName].compactMap { $0 }
                    .joined(separator: " ")
                
                let user = User(id: result.user.uid, fullname: formattedFullName, email: email)
                
                try await setUserData(user: user)
                
                return await .success(try fetchUserData(id))
            }
            
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<FirebaseUser, FirebaseAuthError> {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            let id = result.user.uid
            
            do {
                let user = try await fetchUserData(id)
                
                return .success(user)
            } catch {
                let result = try await Auth.auth().signIn(with: credential)
                let user = User(
                    id: result.user.uid,
                    fullname: result.user.displayName ?? "",
                    email: result.user.email ?? "",
                    imageUrl: nil
                )
                
                let id = result.user.uid
                
                try await setUserData(user: user)
                
                return await .success(try fetchUserData(id))
            }
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    func resetPassword(toEmail email: String) async -> Result<Void, FirebaseAuthError>{
        do {
            let result: Void = try await Auth.auth().sendPasswordReset(withEmail: email)
            return .success(result)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async -> Result<Void, FirebaseAuthError> {
            guard let user = Auth.auth().currentUser else {
                return .failure(FirebaseAuthError(authErrorCode: .userNotFound))
            }
            guard let lastSignInDate = user.metadata.lastSignInDate else {
                return .failure(FirebaseAuthError(authErrorCode: .userNotFound))
            }

            let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)

            do {
                if needsReauth {
                    // Here, handle reauthentication if necessary
                    // For simplicity, we assume user can reauthenticate with saved credentials
                    guard let email = user.email else {
                        return .failure(FirebaseAuthError(authErrorCode: .userNotFound))
                    }
                    let credential = EmailAuthProvider.credential(withEmail: email, password: "user_password")
                    try await user.reauthenticate(with: credential)
                }

                deleteUserData(user.uid)
                
                try await user.delete()
                return .success(())
            } catch {
                let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
                return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
            }
        }
    
    private func fetchUserData(_ id: String) async throws -> FirebaseUser {
        let documentSnapshot = try await Firestore.firestore().collection("users").document(id).getDocument()
        
        if let data = documentSnapshot.data() {
            print("User data fetched: \(data)")
        } else {
            print("No user data found for id: \(id)")
        }
        
        return try documentSnapshot.data(as: FirebaseUser.self)
    }
    
    private func setUserData(user: User) async throws {
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            throw FirebaseAuthError.unknown
        }
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser, merge: true)
    }
    
    func deleteUserData(_ id: String) {
        Firestore.firestore().collection("users").document(id).delete { err in
            if let err = err {
                print("Erreur lors de la suppression des données utilisateur Firestore : \(err)")
            } else {
                print("Données utilisateur Firestore supprimées avec succès.")
            }
        }
    }
}

extension Date {
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date()
        let timeAgo = now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        let range = timeAgo...now
        return range.contains(self)
    }
}
