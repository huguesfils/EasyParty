//
//  LoginWithAppleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation
import SharedDomain

protocol LoginWithAppleUseCase {
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError>
}

struct DefaultLoginWithAppleUseCase: LoginWithAppleUseCase {
    
    let repository: AuthRepository
    
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError> {
        let result = await repository.loginWithApple(token: token, nonce: nonce, email: email, givenName: givenName, familyName: familyName)
        switch result {
        case .success(let user):
            do {
                try saveUserInfo(user)
            } catch {
                return .failure(.unknown)
            }
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func saveUserInfo(_ user: User) throws {
        let data = try JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "currentUser")
    }
}
