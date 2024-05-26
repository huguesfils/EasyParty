//
//  AuthViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

final class AuthViewModel: ObservableObject {
    
    let loginWithAppleUseCase: LoginWithAppleUseCase
    let buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    
    init(loginWithAppleUseCase: LoginWithAppleUseCase, buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase) {
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.buttonLoginInWithAppleUseCase = buttonLoginInWithAppleUseCase
    }
    
    @ViewBuilder
    func getAppleSignInButton() -> AppleSignInButton {
        buttonLoginInWithAppleUseCase.execute(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                Task {
                    await self.loginWithApple(user: user)
                }
            case .failure(let failure):
                self.hasError = failure
            }
        })
    }
    
    @MainActor
    private func loginWithApple(user : AppleSignInUser) async {
        isLoading = true
        let result = await loginWithAppleUseCase.execute(token: user.token, nonce: user.nonce, email: user.email ?? "", givenName: user.givenName, familyName: user.familyName)
        isLoading = false
        switch result {
        case .success(let success):
            break
            // TODO: navigation !!!!!!
        case .failure(let failure):
            hasError = failure
        }
    }
}
