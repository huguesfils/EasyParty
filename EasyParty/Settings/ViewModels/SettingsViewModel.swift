//
//  SettingsViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 30/05/2024.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    let signOutUseCase: SignOutUseCase
    let deleteAccountUseCase: DeleteAccountUseCase
    let comfirmAppleSignInUseCase: ComfirmAppleSignInUseCase
    
    @Published var user: User
    
    init(user: User,
         signOutUseCase: SignOutUseCase,
         deleteAccountUseCase: DeleteAccountUseCase,
         comfirmAppleSignInUseCase: ComfirmAppleSignInUseCase) {
        self.user = user
        self.signOutUseCase = signOutUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.comfirmAppleSignInUseCase = comfirmAppleSignInUseCase
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
}
