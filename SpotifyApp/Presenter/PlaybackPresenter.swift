//
//  PlaybackPresenter.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 12.05.2022.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

private enum Constants {
    static let defaultTrackVolume: Float = 0.5
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var playerViewController: PlayerViewController?
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    private var index = 0
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        guard let songURL = URL(string: track.previewURL ?? "") else {
            return
        }
        player = AVPlayer(url: songURL)
        player?.volume = Constants.defaultTrackVolume
        
        self.track = track
        self.tracks = []
        let playerViewController = PlayerViewController()
        playerViewController.dataSource = self
        playerViewController.delegate = self
        playerViewController.title = track.name
        viewController.present(UINavigationController(rootViewController: playerViewController), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerViewController = playerViewController
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap {
            guard let songURL = URL(string: $0.previewURL ?? "") else {
                return nil
            }
            return AVPlayerItem(url: songURL)
        })
        self.playerQueue?.volume = Constants.defaultTrackVolume
        self.playerQueue?.play()
        
        let playerViewController = PlayerViewController()
        playerViewController.dataSource = self
        playerViewController.delegate = self
        viewController.present(UINavigationController(rootViewController: playerViewController), animated: true)
        self.playerViewController = playerViewController
    }
}

// MARK: - Player Data Source

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

// MARK: - PlayerViewController Delegate

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if index > 0 {
            playerQueue?.pause()
            index -= 1
            guard let playerQueueItems = playerQueue?.items() else {
                return
            }
            playerQueue?.advanceToPreviousItem(for: index, with: playerQueueItems)
            playerQueue?.play()
            playerQueue?.volume = Constants.defaultTrackVolume
            playerViewController?.refreshUI()
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else if let playerQueue = playerQueue, index < playerQueue.items().count - 1 {
            playerQueue.advanceToNextItem()
            index += 1
            playerViewController?.refreshUI()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}
