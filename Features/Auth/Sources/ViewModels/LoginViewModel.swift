//
//  LoginViewModel.swift
//
//
//  Created by Hugues Fils on 07/07/2024.
//

import SwiftUI
import SharedDomain
import Factory

final class LoginViewModel: ObservableObject {
    
    @Injected(\.loginWithAppleUseCase) var loginWithAppleUseCase: LoginWithAppleUseCase
    @Injected(\.buttonLoginInWithAppleUseCase) var buttonLoginInWithAppleUseCase: ButtonLoginInWithAppleUseCase
    @Injected(\.loginWithGoogleUseCase) var loginWithGoogleUseCase: LoginWithGoogleUseCase
    @Injected(\.getGoogleCredentialsUseCase) var getGoogleCredentialsUseCase: GetGoogleCredentialsUseCase
    
    @Published var isLoading = false
    @Published var hasError: Error? = nil
    
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

//getAppleSIgnInButton + loginWithGoogle +
