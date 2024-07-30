//
//  TabCoordinator.swift
//  EasyParty
//
//  Created by Hugues Fils on 30/07/2024.
//

import FlowStacks
import SwiftUI
import Parties

private final class TabCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<TabScreen> = []
    
    func getTabBarActions() -> TabBarViewModelActions {
        .init(showPartyList: { [weak self] in
            self?.showPartyList()
        }, showInviteList: { [weak self] in
            self?.showInviteList()
        }, showAddParty: { [weak self] in
            self?.showAddParty()
        })
    }
    
    func showPartyList() {
        routes.push(.partyList)
    }
    
    func showInviteList() {
        routes.push(.inviteList)
    }
    
    func showAddParty() {
        routes.presentSheet(.addParty)
    }
}

private enum TabScreen: Hashable {
    case partyList
    case inviteList
    case addParty
}

struct TabCoordinator: View {
    @StateObject private var viewModel = TabCoordinatorViewModel()
    
    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            TabBarView().flowDestination(for: TabScreen.self) { screen in
                switch screen {
                case .partyList:
                    PartyListView()
                case .inviteList:
                    InviteListView()
                case .addParty:
                    AddPartyView(party: nil)
                }
            }
        }
    }
}

//TODO: to delete
