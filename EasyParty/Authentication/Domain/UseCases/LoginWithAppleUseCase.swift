//
//  LoginWithAppleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation
import SwiftUI

protocol LoginWithAppleUseCase {
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError>
    func getSignInButton(completion: @escaping (Result<String, AppleSignInError>) -> Void) -> any View
}

struct DefaultLoginWithAppleUseCase: LoginWithAppleUseCase {

    let repository: AuthRepository
    let appleSignInService: AppleSignInService
    
    func execute(token: String, nonce: String, email: String, givenName: String?, familyName: String?) async -> Result<User, AuthError> {
        return await repository.loginWithApple(token: token, nonce: nonce, email: email, givenName: givenName, familyName: familyName)
    }
    
    func getSignInButton(completion: @escaping (Result<String, AppleSignInError>) -> Void) -> any View {
        return appleSignInService.signInButton(completion)
    }
}
