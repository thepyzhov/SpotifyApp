//
//  PlayerControlsView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 12.05.2022.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

private enum Constants {
    static let nameLabelFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let subtitleFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    
    static let buttonSize: CGFloat = 60
    static let backAndNextButtonsXPadding: CGFloat = 40
    
    static let playButtonSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular)
    static let pauseButtonSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular)
    static let backwardButtonSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
    static let forwardButtonSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
    
    static let playButtonImage = UIImage(
        systemName: "play.circle.fill",
        withConfiguration: playButtonSymbolConfiguration
    )
    static let pauseButtonImage = UIImage(
        systemName: "pause.circle.fill",
        withConfiguration: pauseButtonSymbolConfiguration
    )
    static let backwardButtonImage = UIImage(
        systemName: "backward.fill",
        withConfiguration: backwardButtonSymbolConfiguration
    )
    static let forwardButtonImage = UIImage(
        systemName: "forward.fill",
        withConfiguration: forwardButtonSymbolConfiguration
    )
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private var isPlaying = true
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Constants.nameLabelFont
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Constants.subtitleFont
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = Constants.backwardButtonImage
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = Constants.forwardButtonImage
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = Constants.pauseButtonImage
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(slideSlider), for: .valueChanged)
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom + 10, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)
        
        playPauseButton.frame = CGRect(
            x: (width - Constants.buttonSize) / 2,
            y: volumeSlider.bottom + 30,
            width: Constants.buttonSize,
            height: Constants.buttonSize
        )
        backButton.frame = CGRect(
            x: playPauseButton.left - Constants.backAndNextButtonsXPadding - Constants.buttonSize,
            y: playPauseButton.top,
            width: Constants.buttonSize,
            height: Constants.buttonSize
        )
        nextButton.frame = CGRect(
            x: playPauseButton.right + Constants.backAndNextButtonsXPadding,
            y: playPauseButton.top,
            width: Constants.buttonSize,
            height: Constants.buttonSize
        )
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    // MARK: - Button Selectors
    
    @objc private func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        playPauseButton.setImage(
            isPlaying ? Constants.pauseButtonImage : Constants.playButtonImage,
            for: .normal
        )
    }
    
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func slideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
}
