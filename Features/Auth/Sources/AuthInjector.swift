//
//  AuthInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/05/2024.
//

import Foundation
import CloudDBClient
import FirebaseCore
import Factory

extension Container {
    
    public var service: Factory<FirebaseAuthService> {
        self { DefaultFirebaseAuthService(cloudDbClient: self.cloudDBClient.resolve()) }
    }
    
    var repository: Factory<AuthRepository> {
        self { DefaultAuthRepository(authService: self.service.resolve()) }
    }
    
    var loginWithEmailUseCase: Factory<LoginWithEmailUseCase> {
        self { DefaultLoginWithEmailUseCase(repository: self.repository.resolve()) }
    }
    
    var registerWithEmailUseCase: Factory<RegisterWithEmailUseCase> {
        self { DefaultRegisterWithEmailUseCase(repository: self.repository.resolve()) }
    }
    
    var buttonLoginInWithAppleUseCase: Factory<ButtonLoginInWithAppleUseCase> {
        self { DefaultButtonLoginInWithAppleUseCase(appleSignInService: AppInjector.shared.appleService) }
    }
    
    var loginWithAppleUseCase: Factory<LoginWithAppleUseCase> {
        self { DefaultLoginWithAppleUseCase(repository: self.repository.resolve()) }
    }
    
    var getGoogleCredentialsUseCase: Factory<GetGoogleCredentialsUseCase> {
        self { DefaultGetGoogleCredentialsUseCase(googleService: AppInjector.shared.googleService) }
    }
    
    var loginWithGoogleUseCase: Factory<LoginWithGoogleUseCase> {
        self { DefaultLoginWithGoogleUseCase(repository: self.repository.resolve()) }
    }
    
    var resetPasswordUseCase: Factory<ResetPasswordUseCase> {
        self { DefaultResetPasswordUseCase(repository: self.repository.resolve()) }
    }
    
    public static func register() {
        FirebaseApp.configure()
    }
    
    public static func getLoginView() -> LoginView {
        return LoginView(viewModel: .init())
    }
    
    var authService: Factory<FirebaseAuthService> {
        self { DefaultFirebaseAuthService(cloudDbClient: self.cloudDBClient.resolve()) }.singleton
    }
}
