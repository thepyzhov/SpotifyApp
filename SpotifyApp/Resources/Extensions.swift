//
//  Extensions.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 21.04.2022.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}

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
