//
//  AudioTrack.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import Foundation

struct AudioTrack: Codable {
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: [String: String]
    let id: String
    let name: String
    let previewURL: String?
    
    var album: Album?
}
