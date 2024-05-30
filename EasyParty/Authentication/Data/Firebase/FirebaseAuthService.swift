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
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<
        FirebaseUser, FirebaseAuthError
    >
    
    func signOut() throws
    
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
            let user = User(
                id: result.user.uid,
                fullname: result.user.displayName ?? "",
                email: result.user.email ?? "",
                imageUrl: nil
            )
            
            let id = result.user.uid
            
            try await setUserData(user: user)
            
            return await .success(try fetchUserData(id))
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
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
}
// TODO: finir les funcs
// repository AuthRepository -> appelle le service
// transformer le Firebas Error en AuthError
// faire les useCase
// clean le viewmodel
// appel dans les vues
// créer un fichier traduction
//
