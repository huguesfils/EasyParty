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

struct GoogleSignInUser {
    let idToken: String
    let accessToken: String
    let email: String?
    let fullName: String?
}


protocol GoogleSignInService {
    func signIn() async -> Result<GoogleSignInUser, GoogleSignInError>
}

struct DefaultGoogleSignInService: GoogleSignInService {
    @MainActor
    func signIn() async -> Result<GoogleSignInUser, GoogleSignInError> {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window =  windowScene.windows.first,
              let rootViewController =  window.rootViewController else {
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
            
            return .success(.init(idToken: idToken.tokenString,
                                  accessToken: accessToken.tokenString,
                                  email: profile?.email,
                                  fullName: profile?.name))
        } catch {
            return .failure(.unknow)
        }
    }
}
