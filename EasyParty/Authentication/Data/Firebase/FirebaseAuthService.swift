//
//  FirebaseAuthService.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import CryptoKit
import AuthenticationServices
import CloudDBClient

protocol FirebaseAuthService {
    func loginWithEmail(email: String, password: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func registerWithEmail(email: String, password: String, fullname: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func loginWithApple(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<FirebaseUser, FirebaseAuthError>
    
    func resetPassword(toEmail email: String) async -> Result<Void, FirebaseAuthError>
    
    func signOut() throws
    
    func deleteAccount() async -> Result<Void, FirebaseAuthError>
    
    func deleteAppleAccount(authorizationCode: String) async -> Result<Void, FirebaseAuthError>
}

struct DefaultFirebaseAuthService: FirebaseAuthService {
    let cloudDbClient: CloudDBClient
    
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
            let user = User(id: result.user.uid, fullname: fullname, email: email, connectionType: .email)
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
                
                let user = User(id: result.user.uid, fullname: formattedFullName, email: email, connectionType: .apple)
                
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
                    imageUrl: nil,
                    connectionType: .google
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
        do {
            try await deleteUserData(user.uid)
            try await user.delete()
            return .success(())
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    func deleteAppleAccount(authorizationCode: String) async -> Result<Void, FirebaseAuthError> {
        guard let user = Auth.auth().currentUser else {
            return .failure(FirebaseAuthError(authErrorCode: .userNotFound))
        }
        
        do {
            try await Auth.auth().revokeToken(withAuthorizationCode: authorizationCode)
            
            try await deleteUserData(user.uid)
            
            try await user.delete()
            return .success(())
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            return .failure(FirebaseAuthError(authErrorCode: authError ?? .userNotFound))
        }
    }
    
    private func fetchUserData(_ id: String) async throws -> FirebaseUser {
        let result = await cloudDbClient.fetch(FirebaseUser.self, table: .users, id: id)
        switch result {
        case .success(let user):
            return user
        case .failure(let failure):
            throw failure
        }
    }
    
    private func setUserData(user: User) async throws {
        try await cloudDbClient.create(user, table: .users)
    }
    
    private func deleteUserData(_ id: String) async throws {
        try await cloudDbClient.delete(table: .users, id: id)
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
