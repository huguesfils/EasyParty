//
//  FirebaseUser.swift
//  EasyParty
//
//  Created by Hugues Fils on 24/05/2024.
//

import Foundation

struct FirebaseUser: Decodable {
    let id: String
    let fullname: String
    let email: String
    let imageUrl: String?
}

extension FirebaseUser {
  func toDomain() -> User {
      return .init(id: self.id, fullname: self.fullname, email: self.email, imageUrl: self.imageUrl)
  }
}
