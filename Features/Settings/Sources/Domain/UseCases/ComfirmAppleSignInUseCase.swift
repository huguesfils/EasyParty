//
//  ComfirmAppleSignInUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import SwiftUI
import Auth

protocol ComfirmAppleSignInUseCase {
    func execute(completion: @escaping (Result<Void, AppleSignInError>) -> Void) -> AppleSignInButton
}

struct DefaultComfirmAppleSignInUseCase: ComfirmAppleSignInUseCase {
    
    let repository: UserRepository
    
    let appleSignInService: AppleSignInService
    
    func execute(completion: @escaping (Result<Void, AppleSignInError>) -> Void) -> AppleSignInButton {
        return appleSignInService.confirmSignInButton { result in
            switch result {
            case .success(let authorizationCode):
                print("sucess")
                Task {
                    let deleteResult = await repository.deleteAppleAccount(authorizationCode: authorizationCode)
                    DispatchQueue.main.async {
                        switch deleteResult {
                        case .success:
                            print("success useCase")
                            clearUserInfo()
                            
                            completion(.success(Void()))
                        case .failure:
                            print("fail")
                            completion(.failure(.unknown))
                        }
                    }
                }
            case .failure(let error):
                print("failure")
                completion(.failure(error))
            }
        }
    }
    
    private func clearUserInfo() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
