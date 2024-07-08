//
//  ResetPasswordViewModel.swift
//
//
//  Created by Hugues Fils on 07/07/2024.
//

import SwiftUI
import SharedDomain
import Factory

final class ResetPasswordViewModel: ObservableObject {
    
    @Injected(\.resetPasswordUseCase) var resetPasswordUseCase: ResetPasswordUseCase
    
    @Published var email: String = ""
    @Published var hasError: Error? = nil
    @Published var isLoading = false
    @Published var showAlert: Bool = false
    
    var formIsValid: Bool {
       return !email.isEmpty
         && email.contains("@")
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
}
