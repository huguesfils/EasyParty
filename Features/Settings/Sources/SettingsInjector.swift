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
import Factory

extension Container {
    
    var repository: Factory<UserRepository> {
        self { DefaultUserRepository(authService: self.service.resolve()) }
    }
    
    var signOutUseCase: Factory<SignOutUseCase> {
        self { DefaultSignOutUseCase(repository: self.repository.resolve()) }
    }
    
    var deleteAccountUseCase: Factory<DeleteAccountUseCase> {
        self { DefaultDeleteAccountUseCase(repository: self.repository.resolve()) }
    }
    
    var comfirmAppleSignInUseCase: Factory<ComfirmAppleSignInUseCase> {
        self { DefaultComfirmAppleSignInUseCase(repository: self.repository.resolve(), appleSignInService: AppInjector.shared.appleService) }
    }
}
