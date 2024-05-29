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
    @Published var email: String?
    @Published var fullName: String?
    
    let loginWithAppleUseCase: LoginWithAppleUseCase
    let buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    let loginWithGoogleUseCase: LoginWithGoogleUseCase
    let getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase
    let signOutUseCase: SignOutUseCase
    
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    
    init(loginWithAppleUseCase: LoginWithAppleUseCase, buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase, loginWithGoogleUseCase: LoginWithGoogleUseCase, getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase,  signOutUseCase: SignOutUseCase
    ) {
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.buttonLoginInWithAppleUseCase = buttonLoginInWithAppleUseCase
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
        self.getGoogleCredentialsUseCase = getGoogleCredentialsUseCase
        self.signOutUseCase = signOutUseCase
    }
    
    func loadUserInfo() {
        self.email = UserDefaults.standard.string(forKey: "userEmail")
        self.fullName = UserDefaults.standard.string(forKey: "fullName")
    }
    
    @ViewBuilder
    func getAppleSignInButton() -> AppleSignInButton {
        buttonLoginInWithAppleUseCase.execute(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                Task {
                    await self.loginWithApple(user: user)
                    print(user)
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
    
    func signOut() {
        do {
        try signOutUseCase.execute()
            NotificationCenter.default.post(name: .currentUserDidLogOut, object: nil, userInfo: nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private func
    @MainActor
    private func loginWithApple(user : AppleSignInUser) async {
        isLoading = true
        let result = await loginWithAppleUseCase.execute(token: user.token, nonce: user.nonce, email: user.email ?? "", givenName: user.givenName, familyName: user.familyName)
        isLoading = false
        switch result {
        case .success(_):
            NotificationCenter.default.post(name: .currentUserDidLogIn, object: nil, userInfo: nil)
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
        case .success(_):
            NotificationCenter.default.post(name: .currentUserDidLogIn, object: nil, userInfo: nil)
        case .failure(let failure):
            hasError = failure
        }
    }
}
