//
//  AuthCoordinator.swift
//  EasyParty
//
//  Created by Hugues Fils on 26/07/2024.
//

import FlowStacks
import SwiftUI
import Auth

private final class AuthCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<AuthScreen> = []
    
    func getLoginActions() -> LoginViewModelActions {
        .init(showMailLogin: { [weak self] in
            self?.showMailLogin()
        })
    }
    
    func showMailLogin() {
        let actions = MailLoginViewModelActions(showRegister: { [weak self] in
            self?.showRegister()
        }, showResetPassword: { [weak self] in
            self?.showResetPassword()
        })
        
        routes.push(.mailLogin(actions: actions))
    }
    
    func showRegister() {
        routes.push(.register)
    }
    
    func showResetPassword() {
        routes.push(.resetPassword)
    }
}

private enum AuthScreen: Hashable {
    case mailLogin(actions: MailLoginViewModelActions)
    case register
    case resetPassword
}

struct AuthCoordinator: View {
    @StateObject private var viewModel = AuthCoordinatorViewModel()
    
    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            LoginView(actions: viewModel.getLoginActions()).flowDestination(for: AuthScreen.self) { screen in
                switch screen {
                case .mailLogin(let actions):
                    MailLoginView(actions: actions)
                case .register:
                    RegisterView()
                case .resetPassword:
                    ResetPasswordView()
                }
            }
        }
    }
}
