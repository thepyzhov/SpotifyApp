//
//  LibraryToggleView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 13.05.2022.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

private enum Constants {
    static let playlistButtonFrame = CGRect(x: 0, y: 0, width: 100, height: 40)
    static let albumsButtonFrame = CGRect(
        x: playlistButtonFrame.origin.x + playlistButtonFrame.size.width,
        y: 0,
        width: 100,
        height: 40
    )
    
    static let playlistIndicatorViewFrame = CGRect(
        x: 0,
        y: playlistButtonFrame.origin.y + playlistButtonFrame.size.height,
        width: 100,
        height: 3
    )
    static let albumIndicatorViewFrame = CGRect(
        x: 100,
        y: playlistButtonFrame.origin.y + playlistButtonFrame.size.height,
        width: 100,
        height: 3
    )
}

class LibraryToggleView: UIView {
    
    weak var delegate: LibraryToggleViewDelegate?
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistButton)
        addSubview(albumsButton)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
        
        addSubview(indicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = Constants.playlistButtonFrame
        albumsButton.frame = Constants.albumsButtonFrame
        layoutIndicator()
    }
    
    private func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = Constants.playlistIndicatorViewFrame
        case .album:
            indicatorView.frame = Constants.albumIndicatorViewFrame
        }
    }
    
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    // MARK: - Button Targets

    @objc private func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
}
