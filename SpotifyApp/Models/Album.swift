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
}
