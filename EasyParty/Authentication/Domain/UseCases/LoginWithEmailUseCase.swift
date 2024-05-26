//
//  LoginWithEmailUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation

protocol LoginWithEmailUseCase {
    func execute(email: String, password: String) async -> Result<User, AuthError>
}

struct DefaultLoginWithEmailUseCase: LoginWithEmailUseCase {

    let repository: AuthRepository
    
    func execute(email: String, password: String) async -> Result<User, AuthError> {
        return await repository.loginWithEmail(email: email, password: password)
    }
}


