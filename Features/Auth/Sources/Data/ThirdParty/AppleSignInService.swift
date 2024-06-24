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

public enum AppleSignInError: Error {
    case unknown
    case tokenError
}

public struct AppleSignInUser {
    let token: String
    let nonce: String
    let email: String?
    let givenName: String?
    let familyName: String?
}

public protocol AppleSignInService {
    func signInButton(_ completion: @escaping (Result<AppleSignInUser, AppleSignInError>) -> Void) -> AppleSignInButton
    func confirmSignInButton(_ completion: @escaping (Result<String, AppleSignInError>) -> Void) -> AppleSignInButton
}

struct DefaultAppleSignInService: AppleSignInService {
    func signInButton(_ completion: @escaping (Result<AppleSignInUser, AppleSignInError>) -> Void) -> AppleSignInButton {
        AppleSignInButton(onRequest: handleRequest(_:), onCompletion: {
            completion(handleResult($0))
        })
    }
    
    func confirmSignInButton(_ completion: @escaping (Result<String, AppleSignInError>) -> Void) -> AppleSignInButton {
        AppleSignInButton(onRequest: handleRequest(_:), onCompletion: {
            completion(handleResult($0))
        })
    }
    
    let currentNonce = randomNonceString()
    
    private func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce)
    }
    
    private func handleResult(_ result: Result<ASAuthorization, Error>) -> Result<AppleSignInUser, AppleSignInError> {
        switch result {
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                return .failure(.unknown)
            }
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return .failure(.tokenError)
            }
            return .success(.init(token: idTokenString,
                                  nonce: self.currentNonce,
                                  email: appleIDCredential.email,
                                  givenName: appleIDCredential.fullName?.givenName,
                                  familyName: appleIDCredential.fullName?.familyName))
        case .failure:
            return .failure(.unknown)
        }
    }
    
    private func handleResult(_ result: Result<ASAuthorization, Error>) -> Result<String, AppleSignInError> {
        switch result {
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let authorizationCode = appleIDCredential.authorizationCode,
                  let authCodeString = String(data: authorizationCode, encoding: .utf8) else {
                return .failure(.unknown)
            }
            return .success(authCodeString)
            
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

public struct AppleSignInButton: View {
    let onRequest: (ASAuthorizationAppleIDRequest) -> Void
    let onCompletion: (Result<ASAuthorization, any Error>) -> Void
    
    public var body: some View {
        SignInWithAppleButton(.signIn) { request in
            onRequest(request)
        } onCompletion: { result in
            onCompletion(result)
        }
    }
}
