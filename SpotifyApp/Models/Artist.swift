//
//  Artist.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let externalUrls: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case externalUrls = "external_urls"
    }
}
