//
//  EasyPartyApp.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import SwiftUI
import Auth
import Factory

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        return true
    }
}

@main
struct EasyPartyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup { 
            ContentView(viewModel: ContentViewModel())
            .environment(\.colorScheme, .light)
        }
    }
}
