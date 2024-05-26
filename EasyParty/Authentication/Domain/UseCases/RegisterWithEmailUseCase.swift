//
//  RegisterWithEmailUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation

protocol RegisterWithEmailUseCase {
    func execute(email: String, password: String, fullname: String) async -> Result<User, AuthError>
}

struct DefaultRegisterWithEmailUseCase: RegisterWithEmailUseCase {

    let repository: AuthRepository
    
    func execute(email: String, password: String, fullname: String) async -> Result<User, AuthError> {
        return await repository.registerWithEmail(email: email, password: password, fullname: fullname)
    }
}
