//
//  TrackResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 03.05.2022.
//

import Foundation

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
