//
//  SettingsInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import Foundation

struct SettingsInjector {
    private static func service() -> FirebaseAuthService {
        return DefaultFirebaseAuthService()
    }
    
    private static func repository() -> UserRepository {
        return DefaultUserRepository(authService: service())
    }
    
    static func signOut() -> SignOutUseCase {
        return DefaultSignOutUseCase(repository: repository())
    }
    
    static func deleteAccountUseCase() -> DeleteAccountUseCase {
        return DefaultDeleteAccountUseCase(repository: repository())
    }
    
    static func comfirmAppleSignInUseCase() -> ComfirmAppleSignInUseCase {
        return DefaultComfirmAppleSignInUseCase(repository: repository(), appleSignInService: AppInjector.shared.appleService)
    }
}
