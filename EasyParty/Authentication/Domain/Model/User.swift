//
//  User.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
  let id: String
  let fullname: String
  let email: String
  var imageUrl: String?
}

extension User {
  static var mockUser = User(
    id: NSUUID().uuidString, fullname: "John Dorian", email: "test@test.com")
}
