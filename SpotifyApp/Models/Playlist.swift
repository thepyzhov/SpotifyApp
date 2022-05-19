//
//  Playlist.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
