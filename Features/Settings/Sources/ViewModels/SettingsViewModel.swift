//
//  SettingsViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 30/05/2024.
//

import SwiftUI
import SharedDomain
import Auth
import Factory

final class SettingsViewModel: ObservableObject {
    @Injected(\.signOutUseCase) var signOutUseCase: SignOutUseCase
    @Injected(\.deleteAccountUseCase) var deleteAccountUseCase: DeleteAccountUseCase
    @Injected(\.comfirmAppleSignInUseCase) var comfirmAppleSignInUseCase: ComfirmAppleSignInUseCase
    
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    
    @ViewBuilder
    func getAppleSignInButton() -> AppleSignInButton {
        comfirmAppleSignInUseCase.execute(completion: { result in
            print("viewmodel1")
            switch result {
            case .success:
                print("sucess viewmodel")
                    NotificationCenter.default.post(name: .currentUserDidLogOut, object: nil, userInfo: nil)
            case .failure(let error):
                print("Error deleting account: \(error.localizedDescription)")
            }
        })
    }
    
    func signOut() {
        do {
            try signOutUseCase.execute()
            NotificationCenter.default.post(name: .currentUserDidLogOut, object: nil, userInfo: nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteAccount() {
        Task {
            let result = await deleteAccountUseCase.execute()
            switch result {
            case .success:
                NotificationCenter.default.post(name: .currentUserDidLogOut, object: nil, userInfo: nil)
            case .failure(let error):
                print("Error deleting account: \(error.localizedDescription)")
            }
        }
    }
}
