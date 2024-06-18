//
//  DeleteAccountUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 02/06/2024.
//

import Foundation

protocol DeleteAccountUseCase {
    func execute() async -> Result<Void, AuthError>
}

struct DefaultDeleteAccountUseCase: DeleteAccountUseCase {
    
    let repository: UserRepository
    
    func execute() async -> Result<Void, AuthError> {
        clearUserInfo()
        return await repository.deleteAccount()
    }
    
    private func clearUserInfo() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
