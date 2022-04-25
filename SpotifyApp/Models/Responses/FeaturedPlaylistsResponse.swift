//
//  FeaturedPlaylistsResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 25.04.2022.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let displayName: String
    let externalUrls: [String: String]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case id
    }

}
