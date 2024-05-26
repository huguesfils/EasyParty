//
//  LoginWithAppleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation

protocol LoginWithAppleUseCase {
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError>
}

struct DefaultLoginWithAppleUseCase: LoginWithAppleUseCase {
    
    let repository: AuthRepository
    
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError> {
        return await repository.loginWithApple(token: token, nonce: nonce, email: email, givenName: givenName, familyName: familyName)
    }
}
