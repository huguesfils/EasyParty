//
//  AppCoordinator.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/07/2024.
//

import SharedDomain
import Foundation
import SwiftUI

private final class AppCoordinatorViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = (UserDefaults.standard.object(forKey: "currentUser") != nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidLogIn), name: .currentUserDidLogIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidLogOut), name: .currentUserDidLogOut, object: nil)
    }
    
    @MainActor
    @objc func currentUserDidLogIn() {
        isLoggedIn = true
    }
    
    @MainActor
    @objc func currentUserDidLogOut() {
        isLoggedIn = false
    }
}

struct AppCoordinator: View {
    @StateObject private var viewModel = AppCoordinatorViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            TabBarView()
        } else {
            AuthCoordinator()
        }
        
    }
}

