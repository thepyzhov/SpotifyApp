//
//  AlbumDetailsResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 03.05.2022.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}
