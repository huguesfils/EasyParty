//
//  Party.swift
//
//
//  Created by Hugues Fils on 08/07/2024.
//

import Foundation

public struct Party: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let date: Date
    public let partyItems: [PartyItem]
    public let imageUrl: String?
    
    public init(id: String, title: String, date: Date, partyItems: [PartyItem], imageUrl: String?) {
        self.id = id
        self.title = title
        self.date = date
        self.partyItems = partyItems
        self.imageUrl = imageUrl
    }
}

public struct PartyItem: Codable, Identifiable, Equatable {
    public var id = UUID()
    public let title: String
    public var completed: Bool = false
    
    public init(id: UUID = UUID(), title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}

public extension Party {
    static var mock = Party(id: NSUUID().uuidString, title: "Anniversaire HUgues", date: Date(), partyItems: [PartyItem(title: "Chips", completed: false)], imageUrl: "")
}
