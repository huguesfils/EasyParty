//
//  User.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import Foundation

public enum ConnectionType: Codable{
    case email
    case apple
    case google
}

public struct User: Identifiable, Codable, Equatable {
    public let id: String
    let fullname: String
    let email: String
    var imageUrl: String?
    var connectionType: ConnectionType
}

public extension User {
    static var mock = User(
        id: NSUUID().uuidString, fullname: "John Dorian", email: "test@test.com", connectionType: .apple)
}
