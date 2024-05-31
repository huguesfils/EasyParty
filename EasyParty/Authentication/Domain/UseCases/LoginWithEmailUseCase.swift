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
        let result = await repository.loginWithEmail(email: email, password: password)
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


