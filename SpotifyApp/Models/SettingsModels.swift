//
//  SettingsModels.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 23.04.2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
