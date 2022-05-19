//
//  AuthResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 21.04.2022.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String
}
