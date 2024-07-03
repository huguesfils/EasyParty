//
//  CloudDBClientInjector.swift
//
//
//  Created by Hugues Fils on 02/07/2024.
//

import Factory

extension Container {
    
    public var cloudDBClient: Factory<CloudDBClient> {
        self { DefaultCloudDBClient() }
            .singleton
    }
}
