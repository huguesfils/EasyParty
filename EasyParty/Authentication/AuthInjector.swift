//
//  AuthInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/05/2024.
//

import Foundation

struct AppInjector {
    static let shared = AppInjector()
    let appleService = DefaultAppleSignInService()
    let googleService = DefaultGoogleSignInService()
}

struct AuthInjector {
    private static func service() -> FirebaseAuthService {
        return DefaultFirebaseAuthService()
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
    
    static func signOut() -> SignOutUseCase {
        return DefaultSignOutUseCase(repository: repository())
    }
}
