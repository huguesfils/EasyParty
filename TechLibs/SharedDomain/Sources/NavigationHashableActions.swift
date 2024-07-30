//
//  File.swift
//  
//
//  Created by Hugues Fils on 26/07/2024.
//

import Foundation

public protocol NavigationHashableActions: Hashable {
    var hashId: String { get }
}

extension NavigationHashableActions {
    public var hashId: String { UUID().uuidString }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashId == rhs.hashId
    }
}

extension NavigationHashableActions {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashId)
    }
}
