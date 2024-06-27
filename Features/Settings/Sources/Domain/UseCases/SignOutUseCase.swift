//
//  SignOutUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 29/05/2024.
//

import Foundation

protocol SignOutUseCase {
    func execute() throws
}

struct DefaultSignOutUseCase: SignOutUseCase {

    let repository: UserRepository
    
    func execute() throws {
        clearUserInfo()
        return try repository.signOut()
    }
    
    private func clearUserInfo() {
            UserDefaults.standard.removeObject(forKey: "currentUser")
        }
}
