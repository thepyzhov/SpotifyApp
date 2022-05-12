//
//  Album.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 13.05.2022.
//

import Foundation

struct Album: Codable {
    let albumType: String
    let availableMarkets: [String]
    let id: String
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [Artist]
    
    var images: [APIImage]
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case id
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case artists
        case images
    }
}
