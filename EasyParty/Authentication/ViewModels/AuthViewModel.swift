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
   
    let loginWithEmailUseCase: LoginWithEmailUseCase
    let registerWithEmailUseCase: RegisterWithEmailUseCase
    let loginWithAppleUseCase: LoginWithAppleUseCase
    let buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    let loginWithGoogleUseCase: LoginWithGoogleUseCase
    let getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase
    let resetPAsswordUseCase: ResetPasswordUseCase
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    @Published var showAlert: Bool = false

    init(loginWithEmailUseCase: LoginWithEmailUseCase, registerWithEmailUseCase: RegisterWithEmailUseCase, loginWithAppleUseCase: LoginWithAppleUseCase, buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase, loginWithGoogleUseCase: LoginWithGoogleUseCase, getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase, resetPasswordUseCase: ResetPasswordUseCase) {
        self.loginWithEmailUseCase = loginWithEmailUseCase
        self.registerWithEmailUseCase = registerWithEmailUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.buttonLoginInWithAppleUseCase = buttonLoginInWithAppleUseCase
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
        self.getGoogleCredentialsUseCase = getGoogleCredentialsUseCase
        self.resetPAsswordUseCase = resetPasswordUseCase
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
    
    
    @MainActor
    func signInWithEmailPassword() async {
        isLoading = true
        let result = await loginWithEmailUseCase.execute(email: email, password: password)
        isLoading = false
        switch result {
        case .success(_):
            NotificationCenter.default.post(name: .currentUserDidLogIn, object: nil, userInfo: nil)
        case .failure(let failure):
            self.hasError = failure
            showAlert = true
        }
    }
    
    @MainActor
    func registerWithEmailPassword() async {
        isLoading = true
        let result = await registerWithEmailUseCase.execute(email: email, password: password, fullname: fullname)
        isLoading = false
        switch result {
        case .success(_):
            NotificationCenter.default.post(name: .currentUserDidLogIn, object: nil, userInfo: nil)
        case .failure(let failure):
            self.hasError = failure
            showAlert = true
        }
    }
    
    @MainActor
    func resetPassword() async {
        isLoading = true
        let result = await resetPAsswordUseCase.execute(email: email)
        isLoading = false
        switch result {
        case .success(_):
            print("Password reset link sent successfully")
        case .failure(let failure):
            self.hasError = failure
            showAlert = true
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
