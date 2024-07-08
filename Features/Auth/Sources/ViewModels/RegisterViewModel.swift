//
//  RegisterViewModel.swift
//
//
//  Created by Hugues Fils on 07/07/2024.
//

import SwiftUI
import SharedDomain
import Factory

final class RegisterViewModel: ObservableObject {
    
    @Injected(\.registerWithEmailUseCase) var registerWithEmailUseCase: RegisterWithEmailUseCase
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    @Published var showAlert: Bool = false
    
    var formIsValid: Bool {
        return !email.isEmpty
          && email.contains("@")
          && !password.isEmpty
          && password.count > 5
          && confirmPassword == password
          && !fullname.isEmpty
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
}
