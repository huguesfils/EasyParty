//
//  AuthInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/05/2024.
//

import Foundation
import CloudDBClient

struct AuthInjector {
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
}
