//
//  AppInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import Foundation

struct AppInjector {
    static let shared = AppInjector()
    let appleService = DefaultAppleSignInService()
    let googleService = DefaultGoogleSignInService()
}
