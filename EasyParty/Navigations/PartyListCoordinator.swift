//
//  PartiesCoordinator.swift
//  EasyParty
//
//  Created by Hugues Fils on 07/08/2024.
//

import FlowStacks
import SwiftUI
import Parties
import SharedDomain
import Settings

private final class PartiesCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<PartiesScreen> = []
    
    func getPartyListActions() -> PartyListViewModelActions {
        .init(showSettings: { [weak self] in
            self?.showSettings()
        })
    }
    
    func showSettings() {
        guard let data = UserDefaults.standard.object(forKey: "currentUser") as? Data,
            let user = try? JSONDecoder().decode(User.self, from: data) else {
            return
        }
        routes.presentSheet(.settings(user: user))
    }
}

private enum PartiesScreen: Hashable {
    case settings(user: User)
}

struct PartiesCoordinator: View {
    @StateObject private var viewModel = PartiesCoordinatorViewModel()
    
    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            PartyListView(actions: viewModel.getPartyListActions()).flowDestination(for: PartiesScreen.self) { screen in
                switch screen {
                case .settings(let user):
                    SettingsCoordinator(user: user)
                }
            }
        }
    }
}
