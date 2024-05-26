//
//  GoogleSignInService.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/05/2024.
//

import Foundation
import GoogleSignIn
import Firebase

enum GoogleSignInError: Error {
    case noRootViewController
    case noIdToken
    case unknow
}

protocol GoogleSignInService {
    func signIn() async -> Result<(idToken: String, accessToken: String, profile: GIDProfileData?), GoogleSignInError>
}

struct DefaultGoogleSignInService: GoogleSignInService {
    func signIn() async -> Result<(idToken: String, accessToken: String, profile: GIDProfileData?), GoogleSignInError> {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root view controller!")
            return .failure(.noRootViewController)
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = userAuthentication.user.idToken else {
                throw GoogleSignInError.noIdToken
            }
            let accessToken = userAuthentication.user.accessToken
            let profile = userAuthentication.user.profile
            
            return .success((idToken.tokenString, accessToken.tokenString, profile))
        } catch {
            return .failure(.unknow)
        }
    }
}
