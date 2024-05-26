//
//  EasyPartyApp.swift
//  EasyParty
//
//  Created by Hugues Fils on 22/05/2024.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct EasyPartyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
