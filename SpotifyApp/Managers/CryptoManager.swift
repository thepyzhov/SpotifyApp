//
//  CryptoManager.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 21.04.2022.
//

import Foundation
import CryptoKit

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

fileprivate func |> <A, B>(a: A, f: (A) -> B) -> B {
    f(a)
}

fileprivate func |> <A, B>(a: A, f: (A) throws -> B) throws -> B {
    try f(a)
}

final class CryptoManager {
    static let shared = CryptoManager()
    
    private init() {}

    enum PKCEError: Error {
        case failedToGenerateRandomOctets
        case failedToCreateChallengeForVerifier
    }
    
    public func generateVerifier() throws -> String {
        return try 32 |> generateCryptographicallySecureRandomOctets |> base64URLEncode
    }
    
    public func challenge(for verifier: String) throws -> String {
        let challenge = verifier // String
            .data(using: .ascii) // Decode back to [UInt8] -> Data?
            .map { SHA256.hash(data: $0) } // Hash -> SHA256.Digest?
            .map { base64URLEncode(octets: $0) } // base64URLEncode
        
        if let challenge = challenge {
            return challenge
        } else {
            throw PKCEError.failedToCreateChallengeForVerifier
        }
    }

    private func generateCryptographicallySecureRandomOctets(count: Int) throws -> [UInt8] {
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
        if status == errSecSuccess {
            return octets
        } else {
            throw PKCEError.failedToGenerateRandomOctets
        }
    }

    private func base64URLEncode<S>(octets: S) -> String where S: Sequence, UInt8 == S.Element {
        let data = Data(octets)
        return data
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: .whitespaces)
    }
}
