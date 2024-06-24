//
//  AuthInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/05/2024.
//

import Foundation
import CloudDBClient
import FirebaseCore

public struct AuthInjector {
    private static func cloudDBClient() -> CloudDBClient {
            return DefaultCloudDBClient()
        }
    
    private static func service() -> FirebaseAuthService {
        return DefaultFirebaseAuthService(cloudDbClient: cloudDBClient())
    }
    
    private static func repository() -> AuthRepository {
        return DefaultAuthRepository(authService: service())
    }
    
    static func loginWithEmailUseCase() -> LoginWithEmailUseCase {
        return DefaultLoginWithEmailUseCase(repository: repository())
    }
    
    static func registerWithEmailUseCase() -> RegisterWithEmailUseCase {
        return DefaultRegisterWithEmailUseCase(repository: repository())
    }
    
    static func buttonLoginInWithAppleUseCase() -> ButtonLoginInWithAppleUseCase {
        return DefaultButtonLoginInWithAppleUseCase(appleSignInService: AppInjector.shared.appleService)
    }
    
    static func loginWithAppleUseCase() -> LoginWithAppleUseCase {
        return DefaultLoginWithAppleUseCase(repository: repository())
    }
    
    static func getGoogleCredentialsUseCase() -> GetGoogleCredentialsUseCase {
        return DefaultGetGoogleCredentialsUseCase(googleService: AppInjector.shared.googleService)
    }
    
    static func loginWithGoogle() -> LoginWithGoogleUseCase {
        return DefaultLoginWithGoogleUseCase(repository: repository())
    }
    
    static func resetPasswordUseCase() -> ResetPasswordUseCase {
        return DefaultResetPasswordUseCase(repository: repository())
    }
    
    public static func register() {
        FirebaseApp.configure()
    }
    
    public static func getLoginView() -> LoginView {
        return LoginView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))
    }
    
    public static func authService() -> FirebaseAuthService {
        return DefaultFirebaseAuthService(cloudDbClient: cloudDBClient())
    }
}
