//
//  AuthViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

final class AuthViewModel: ObservableObject {
    
    let loginWithAppleUseCase: LoginWithAppleUseCase
    let buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    let loginWithGoogleUseCase: LoginWithGoogleUseCase
    let getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase
    
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    
    init(loginWithAppleUseCase: LoginWithAppleUseCase, buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase, loginWithGoogleUseCase: LoginWithGoogleUseCase, getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase) {
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.buttonLoginInWithAppleUseCase = buttonLoginInWithAppleUseCase
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
        self.getGoogleCredentialsUseCase = getGoogleCredentialsUseCase
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
    func loginWithGoogle() async {
        isLoading = true
        let result = await getGoogleCredentialsUseCase.execute()
        isLoading = false
        switch result {
        case .success(let user):
            await loginWithGoogle(user: user)
        case .failure(let failure):
            hasError = failure
        }
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

    @MainActor
    private func loginWithGoogle(user : GoogleSignInUser) async {
        isLoading = true
        let result = await loginWithGoogleUseCase.execute(idToken: user.idToken, accessToken: user.accessToken)
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
