//
//  AppleSignInService.swift
//  EasyParty
//
//  Created by Hugues Fils on 23/05/2024.
//

import Foundation
import AuthenticationServices
import CryptoKit
import SwiftUI

enum AppleSignInError: Error {
    case unknown
    case tokenError
}

protocol AppleSignInService {
    func signInButton(_ completion: @escaping (Result<String, AppleSignInError>) -> Void) -> any View
}

struct DefaultAppleSignInService: AppleSignInService {
    func signInButton(_ completion: @escaping (Result<String, AppleSignInError>) -> Void) -> any View {
        SignInWithAppleButton(.signIn) { request in
            handleRequest(request)
        } onCompletion: { result in
            completion(handleResult(result))
        }
    }
    
    let currentNonce = randomNonceString()
    
    private func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce)
    }
    
    private func handleResult(_ result: Result<ASAuthorization, Error>) -> Result<String, AppleSignInError> {
        switch result {
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                return .failure(.unknown)
            }
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return .failure(.tokenError)
            }
            return .success(idTokenString)
        case .failure:
            return .failure(.unknown)
        }
    }
    
    private static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
