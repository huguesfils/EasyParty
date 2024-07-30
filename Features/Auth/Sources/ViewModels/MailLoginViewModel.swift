//
//  MailLoginViewModel.swift
//
//
//  Created by Hugues Fils on 07/07/2024.
//


import SwiftUI
import SharedDomain
import Factory

public struct MailLoginViewModelActions: NavigationHashableActions {
    let showRegister: () -> Void
    let showResetPassword: () -> Void
    
    public init(showRegister: @escaping () -> Void, showResetPassword: @escaping () -> Void) {
        self.showRegister = showRegister
        self.showResetPassword = showResetPassword
    }
}

final class MailLoginViewModel: ObservableObject {
    
    @Injected(\.loginWithEmailUseCase) var loginWithEmailUseCase: LoginWithEmailUseCase
    
    private let actions: MailLoginViewModelActions
    
    init(actions: MailLoginViewModelActions) {
        self.actions = actions
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    @Published var showAlert: Bool = false
    
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
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
    
    func registerBtnTapped() {
        self.actions.showRegister()
    }
    
    func resetPasswordBtnTapped() {
        self.actions.showResetPassword()
    }
}
