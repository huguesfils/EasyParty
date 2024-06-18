//
//  UserRepository.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import Foundation

protocol UserRepository {
    
    func signOut() throws
    
    func deleteAccount() async -> Result<Void, AuthError>
    
    func deleteAppleAccount(authorizationCode: String) async -> Result<Void, AuthError>
}

struct DefaultUserRepository: UserRepository {
    
    let authService: FirebaseAuthService
    
    func signOut() throws {
        return try authService.signOut()
    }
    
    func deleteAccount() async -> Result<Void, AuthError> {
        return await authService.deleteAccount()
            .mapError { $0.toDomain() }
    }
    
    func deleteAppleAccount(authorizationCode: String) async -> Result<Void, AuthError> {
        return await authService.deleteAppleAccount(authorizationCode: authorizationCode)
            .mapError { $0.toDomain() }
    }
}



