//
//  AuthRepository.swift
//  EasyParty
//
//  Created by Hugues Fils on 24/05/2024.
//

import Foundation

protocol AuthRepository {
    func loginWithEmail(email: String, password: String) async -> Result<User, AuthError>
    
    func registerWithEmail(email: String, password: String, fullname: String) async -> Result<User, AuthError>
    
    func loginWithApple(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError>
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<User, AuthError>
    
    func resetPassword(toEmail email: String) async -> Result<Void, AuthError>
    
}

struct DefaultAuthRepository: AuthRepository {
    
    let authService: FirebaseAuthService
    
    func loginWithEmail(email: String, password: String) async -> Result<User, AuthError> {
        return await authService.loginWithEmail(email: email, password: password)
            .map { $0.toDomain() }
            .mapError { $0.toDomain() }
    }
    
    func registerWithEmail(email: String, password: String, fullname: String) async -> Result<User, AuthError> {
        return await authService.registerWithEmail(email: email, password: password, fullname: fullname)
            .map { $0.toDomain() }
            .mapError { $0.toDomain() }
    }
    
    func loginWithApple(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError> {
        return await authService.loginWithApple(token: token, nonce: nonce, email: email, givenName: givenName, familyName: familyName)
            .map { $0.toDomain() }
            .mapError { $0.toDomain() }
    }
    
    func loginWithGoogle(idToken: String, accessToken: String) async -> Result<User, AuthError> {
        return await authService.loginWithGoogle(idToken: idToken, accessToken: accessToken)
            .map { $0.toDomain() }
            .mapError { $0.toDomain() }
    }
    
    func resetPassword(toEmail email: String) async -> Result<Void, AuthError> {
        return await authService.resetPassword(toEmail: email)
            .mapError { $0.toDomain() }
    }
}


