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

public struct SettingsViewModelActions: NavigationHashableActions{
    let showTerms: () -> Void
    let showActivity: () -> Void
    
    public init(showTerms: @escaping () -> Void, showActivity: @escaping () -> Void) {
        self.showTerms = showTerms
        self.showActivity = showActivity
    }
}

final class SettingsViewModel: ObservableObject {
    @Injected(\.signOutUseCase) var signOutUseCase: SignOutUseCase
    @Injected(\.deleteAccountUseCase) var deleteAccountUseCase: DeleteAccountUseCase
    @Injected(\.comfirmAppleSignInUseCase) var comfirmAppleSignInUseCase: ComfirmAppleSignInUseCase
    
    @Published var user: User
    
    private let actions: SettingsViewModelActions
    
    init(user: User, actions: SettingsViewModelActions) {
        self.user = user
        self.actions = actions
    }
    
    @ViewBuilder
    func getAppleSignInButton() -> AppleSignInButton {
        comfirmAppleSignInUseCase.execute(completion: { result in
            switch result {
            case .success:
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
    
    func termsBtnTapped() {
        self.actions.showTerms()
    }
    
    func activityBtnTapped() {
           self.actions.showActivity()
       }
}
