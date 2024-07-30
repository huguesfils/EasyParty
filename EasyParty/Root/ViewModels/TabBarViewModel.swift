//
//  TabBarViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 30/07/2024.
//

import SwiftUI
import SharedDomain

public struct TabBarViewModelActions {
    let showPartyList: () -> Void
    let showInviteList: () -> Void
    let showAddParty: () -> Void
    
    public init(showPartyList: @escaping () -> Void, showInviteList: @escaping () -> Void, showAddParty: @escaping () -> Void) {
        self.showPartyList = showPartyList
        self.showInviteList = showInviteList
        self.showAddParty = showAddParty
    }
}

final class TabBarViewModel: ObservableObject {
    private let actions: TabBarViewModelActions
    
    init(actions: TabBarViewModelActions) {
        self.actions = actions
    }
    
    func partyListBtnTapped() {
        self.actions.showPartyList()
    }
    
    func inviteListBtnTapped() {
        self.actions.showInviteList()
    }
    
    func addPartyBtnTapped() {
        self.actions.showAddParty()
    }
}
