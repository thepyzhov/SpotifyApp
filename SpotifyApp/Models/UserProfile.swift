//
//  UserProfile.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String
    let email: String
    let explicitContent: [String: Bool]
    let externalUrls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
}
