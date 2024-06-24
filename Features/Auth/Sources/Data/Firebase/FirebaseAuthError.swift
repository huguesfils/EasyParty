//
//  FirebaseAuthError.swift
//  EasyParty
//
//  Created by Hugues Fils on 24/05/2024.
//

import Foundation
import FirebaseAuth

public enum FirebaseAuthError: Error {
    case invalidCredential
    case unknown
    
    init(authErrorCode: AuthErrorCode.Code) {
        switch authErrorCode {
        case .invalidCredential, .userNotFound:
            self = .invalidCredential
        default:
            self = .unknown
        }
    }
}

public extension FirebaseAuthError {
  func toDomain() -> AuthError {
      switch self {
      case .invalidCredential:
          return .invalidCredential
      case .unknown:
          return .unknown
      }
  }
}
