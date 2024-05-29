//
//  LoginWithGoogleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

//import Foundation
//
//protocol LoginWithGoogleUseCase {
//    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError>
//}
//
//struct DafaultLoginWithGoogleUseCase: LoginWithGoogleUseCase {
//    let repository: AuthRepository
//    
//    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError> {
//        return await repository.loginWithGoogle(idToken: idToken, accessToken: accessToken)
//    }
//}

import Foundation

protocol LoginWithGoogleUseCase {
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError>
}

struct DefaultLoginWithGoogleUseCase: LoginWithGoogleUseCase {
    let repository: AuthRepository
    
    func execute(idToken: String, accessToken: String) async -> Result<User, AuthError> {
        let result = await repository.loginWithGoogle(idToken: idToken, accessToken: accessToken)
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
