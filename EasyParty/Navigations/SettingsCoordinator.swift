//
//  SettingsCoordinator.swift
//  EasyParty
//
//  Created by Hugues Fils on 07/08/2024.
//

import FlowStacks
import SwiftUI
import Parties
import SharedDomain
import Settings

private final class SettingsCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<SettingsScreen> = []
    
    func getSettingsActions() -> SettingsViewModelActions {
        .init(showTerms: { [weak self] in
            self?.showTerms()
        }, showActivity: {[weak self] in
            self?.showActivity()
        })
    }
    
    func showTerms() {
        routes.push(.terms)
    }
    
    func showActivity() {
        routes.presentSheet(.activity)
    }
}


private enum SettingsScreen: Hashable {
    case terms
    case activity
}

struct SettingsCoordinator: View {
    @StateObject private var viewModel = SettingsCoordinatorViewModel()
    let user: User
    
    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            SettingsView(user: user, actions: viewModel.getSettingsActions()).flowDestination(for: SettingsScreen.self) { screen in
                switch screen {
                case .terms:
                    TermsAndConditionsView()
                case .activity:
                    ActivityView(activityItems: ["Découvrez l'application Easy Party ! Téléchargez-la ici : [lien de téléchargement]"])
                }
            }
        }
    }
}

