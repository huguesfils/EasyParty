//
//  PartyListViewModel.swift
//
//
//  Created by Hugues Fils on 07/08/2024.
//

import SwiftUI
import SharedDomain
import Factory

public struct PartyListViewModelActions {
    let showSettings: () -> Void
    
    public init(showSettings: @escaping () -> Void) {
        self.showSettings = showSettings
    }
}

final class PartyListViewModel: ObservableObject {
    private let actions: PartyListViewModelActions
    
    init(actions: PartyListViewModelActions) {
        self.actions = actions
    }
    
    func settingsBtnTapped() {
        self.actions.showSettings()
    }
}
