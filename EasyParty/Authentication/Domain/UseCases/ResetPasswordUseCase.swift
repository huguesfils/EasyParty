//
//  ResetPasswordUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 31/05/2024.
//

import Foundation

protocol ResetPasswordUseCase {
    func execute(email: String) async -> Result<Void, AuthError>
}

struct DefaultResetPasswordUseCase: ResetPasswordUseCase {
    
    let repository: AuthRepository
    
    func execute(email: String) async -> Result<Void, AuthError> {
        let result = await repository.resetPassword(toEmail: email)
        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
