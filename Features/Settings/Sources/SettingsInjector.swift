//
//  SettingsInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import Foundation
import CloudDBClient
import SharedDomain
import Auth

public struct SettingsInjector {
    private static func cloudDBClient() -> CloudDBClient {
        return DefaultCloudDBClient()
    }
    
    private static func repository() -> UserRepository {
        return DefaultUserRepository(authService: AuthInjector.authService())
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
    
    public static func getSettingsView(_ user: User) -> SettingsView {
        return  SettingsView(viewModel: SettingsViewModel(user: user, signOutUseCase: SettingsInjector.signOut(), deleteAccountUseCase: SettingsInjector.deleteAccountUseCase(), comfirmAppleSignInUseCase: SettingsInjector.comfirmAppleSignInUseCase()))
    }
}
