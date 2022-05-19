//
//  User.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 16.05.2022.
//

import Foundation

struct User: Codable {
    let displayName: String
    let externalUrls: [String: String]
    let id: String
}
