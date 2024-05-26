//
//  AuthError.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import Foundation

enum AuthError: Error {
    case invalidCredential
    case unknown
    case tokenError
    
    var description: String {
        switch self {
        case .invalidCredential:
            return "Il semble qu'il n'y ait aucun compte associé à cette adresse e-mail. Créez un compte pour continuer."
        case .unknown:
            return "Une erreur inconnue s'est produite. Veuillez réessayer."
        case .tokenError:
            return "ID token manquant"
        }
    }
}
