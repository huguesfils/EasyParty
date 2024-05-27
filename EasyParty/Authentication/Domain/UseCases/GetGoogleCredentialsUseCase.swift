//
//  GetGoogleCredentialsUseCase.swift
//  EasyParty
//
//  Created by Hugues Fils on 27/05/2024.
//

import Foundation

protocol GetGoogleCredentialsUseCase {
   func execute() async -> Result<GoogleSignInUser, GoogleSignInError>
}

struct DefaultGetGoogleCredentialsUseCase: GetGoogleCredentialsUseCase {
    
    let googleService: GoogleSignInService
    
    func execute() async -> Result<GoogleSignInUser, GoogleSignInError> {
        return await googleService.signIn()
    }
}
