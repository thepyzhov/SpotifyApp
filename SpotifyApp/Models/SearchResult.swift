//
//  SearchResult.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 10.05.2022.
//

import Foundation

enum SearchResult {
    case album(model: Album)
    case artist(model: Artist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
