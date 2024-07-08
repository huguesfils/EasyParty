//
//  AddPartyListViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 20/03/2024.
//

import CloudDBClient
import Foundation
import SwiftUI
import _PhotosUI_SwiftUI
import SharedDomain

final class AddPartyListViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var partyImageData: Data?
    @Published var isImageLoading = false
    
    @Published var party: Party?
        
        init(party: Party?) {
            self.party = party
        }
}
