//
//  LibraryAlbumsResponse.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 18.05.2022.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}
