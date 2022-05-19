//
//  PlaylistDetailsResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 03.05.2022.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
