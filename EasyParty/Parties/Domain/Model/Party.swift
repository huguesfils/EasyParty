//
//  Party.swift
//  EasyParty
//
//  Created by Hugues Fils on 20/03/2024.
//

import FirebaseFirestore
import Foundation

struct Party: Codable, Identifiable, Equatable {
  @DocumentID var id: String?
  var title: String
  var date: Date
  var description: String
  var partyItems: [PartyItem]
  var imageUrl: String?
}

struct PartyItem: Codable, Identifiable, Equatable {
  var id = UUID()
  var title: String
  var completed: Bool = false
}
