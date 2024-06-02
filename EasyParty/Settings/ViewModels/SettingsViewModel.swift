//
//  SettingsViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 30/05/2024.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    let signOutUseCase: SignOutUseCase
    let deleteAccountUseCase: DeleteAccountUseCase
    
    @Published var email: String?
    @Published var fullName: String?
    
    init(signOutUseCase: SignOutUseCase, deleteAccountUseCase: DeleteAccountUseCase, email: String? = nil, fullName: String? = nil) {
        self.signOutUseCase = signOutUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.email = email
        self.fullName = fullName
    }
    
    func loadUserInfo() {
        guard let data = UserDefaults.standard.object(forKey: "currentUser") as? Data else { return }
        let user = try? JSONDecoder().decode(User.self, from: data)
        self.email = user?.email
        self.fullName = user?.fullname
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
