//
//  AppInjector.swift
//  EasyParty
//
//  Created by Hugues Fils on 11/06/2024.
//

import Foundation

public struct AppInjector {
    public static let shared = AppInjector()
    public var appleService: AppleSignInService = { DefaultAppleSignInService() }()
    public let googleService: GoogleSignInService = { DefaultGoogleSignInService() }()
}
