//
//  RecommendationsResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 25.04.2022.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
