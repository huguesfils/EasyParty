//
//  ContentViewViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 29/05/2024.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidLogIn), name: .currentUserDidLogIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidLogOut), name: .currentUserDidLogOut, object: nil)
    }
    
    @MainActor
    @objc func currentUserDidLogIn() {
        isLoggedIn = true
    }
    
    @MainActor
    @objc func currentUserDidLogOut() {
        isLoggedIn = false
    }
}

extension NSNotification.Name {
    static let currentUserDidLogIn = NSNotification.Name("fr.app.currentUserDidLogIn")
    static let currentUserDidLogOut = NSNotification.Name("fr.app.currentUserDidLogOut")
}


