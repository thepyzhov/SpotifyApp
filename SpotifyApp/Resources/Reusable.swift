//
//  Reusable.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 20.05.2022.
//

import Foundation

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}
