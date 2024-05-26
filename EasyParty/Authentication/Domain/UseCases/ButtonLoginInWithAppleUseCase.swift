//
//  ButtonLoginInWithAppleUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/05/2024.
//

import SwiftUI

protocol ButtonLoginInWithAppleUseCase {
    func execute(completion: @escaping (Result<AppleSignInUser, AppleSignInError>) -> Void) -> AppleSignInButton
}

struct DefaultButtonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase {
    
    let appleSignInService: AppleSignInService
 
    func execute(completion: @escaping (Result<AppleSignInUser, AppleSignInError>) -> Void) -> AppleSignInButton {
        return appleSignInService.signInButton(completion)
    }
}

