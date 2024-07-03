//
//  AuthViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI
import SharedDomain
import Factory

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

final class AuthViewModel: ObservableObject {
   
    @Injected(\.loginWithEmailUseCase) var loginWithEmailUseCase: LoginWithEmailUseCase
    @Injected(\.registerWithEmailUseCase) var registerWithEmailUseCase: RegisterWithEmailUseCase
    @Injected(\.loginWithAppleUseCase) var loginWithAppleUseCase: LoginWithAppleUseCase
    @Injected(\.buttonLoginInWithAppleUseCase) var buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    @Injected(\.loginWithGoogleUseCase) var loginWithGoogleUseCase: LoginWithGoogleUseCase
    @Injected(\.getGoogleCredentialsUseCase) var getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase
    @Injected(\.resetPasswordUseCase) var resetPasswordUseCase: ResetPasswordUseCase
    //TODO injector & specific viewmodel
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    @Published var showAlert: Bool = false
    
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
        let result = await resetPasswordUseCase.execute(email: email)
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
