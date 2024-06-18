//
//  LoginWithGoogleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation
import SharedDomain

protocol LoginWithGoogleUseCase {
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError>
}

struct DefaultLoginWithGoogleUseCase: LoginWithGoogleUseCase {
    let repository: AuthRepository
    
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError> {
        let result = await repository.loginWithGoogle(idToken: idToken, accessToken: accessToken)
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
