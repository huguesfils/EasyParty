//
//  LoginWithGoogleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation

protocol LoginWithGoogleUseCase {
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError>
}

struct DafaultLoginWithGoogleUseCase: LoginWithGoogleUseCase {
    let repository: AuthRepository
    
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError> {
        return await repository.loginWithGoogle(idToken: idToken, accessToken: accessToken)
    }
}
