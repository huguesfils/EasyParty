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
        let result = await repository.loginWithApple(token: token, nonce: nonce, email: email, givenName: givenName, familyName: familyName)
        switch result {
        case .success(let user):
            saveUserInfo(email: user.email, fullName: user.fullname)
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func saveUserInfo(email: String?, fullName: String?) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(fullName, forKey: "fullName")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
}
