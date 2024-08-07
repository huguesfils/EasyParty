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

public struct User: Identifiable, Codable, Hashable {
    public let id: String
    public let fullname: String
    public let email: String
    public var imageUrl: String?
    public var connectionType: ConnectionType
    
    public init(id: String, fullname: String, email: String, imageUrl: String? = nil, connectionType: ConnectionType) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.imageUrl = imageUrl
        self.connectionType = connectionType
    }
}

public extension User {
    static var mock = User(
        id: NSUUID().uuidString, fullname: "John Dorian", email: "test@test.com", connectionType: .apple)
}
