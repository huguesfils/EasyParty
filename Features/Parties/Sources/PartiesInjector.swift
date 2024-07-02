//
//  PartiesInjector.swift
//  
//
//  Created by Hugues Fils on 02/07/2024.
//

import Foundation

public struct PartiesInjector {
    
    public static func getAddPartyView() -> AddPartyView {
        return  AddPartyView()
    }
    
    public static func getInviteListView() -> InviteListView {
            return  InviteListView()
        }
    
    public static func getPartyListView() -> PartyListView {
            return  PartyListView()
        }
    
}
