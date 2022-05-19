//
//  AVQueuePlayer+Extensions.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 20.05.2022.
//

import Foundation
import AVFoundation

extension AVQueuePlayer {
    func advanceToPreviousItem(for currentItem: Int, with initialItems: [AVPlayerItem]) {
        self.removeAllItems()
        
        for index in currentItem..<initialItems.count {
            let playerItem: AVPlayerItem? = initialItems[index]
            guard let playerItem = playerItem else {
                continue
            }
            if self.canInsert(playerItem, after: nil) {
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
                self.insert(playerItem, after: nil)
            }
        }
    }
}
