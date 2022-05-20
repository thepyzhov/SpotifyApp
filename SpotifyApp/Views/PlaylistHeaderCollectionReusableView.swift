//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 04.05.2022.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

private enum Constants {
    static let nameLabelFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let ownerLabelFont = UIFont.systemFont(ofSize: 18, weight: .light)
    
    static let labelHeight: CGFloat = 44
    static let labelWidthPadding: CGFloat = 20
    static let labelPositionX: CGFloat = 10
    
    static let playAllButtonSize: CGFloat = 60
    static let playAllButtonCornerRadius: CGFloat = playAllButtonSize / 2
    static let playAllButtonPadding: CGFloat = 90 - playAllButtonSize * 0.25
    static let playAllButtonSymbolPointSize: CGFloat = playAllButtonSize / 2
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView, Reusable {    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.nameLabelFont
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = Constants.descriptionLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = Constants.ownerLabelFont
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: Constants.playAllButtonSymbolPointSize,
                weight: .regular
            )
        )
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.playAllButtonCornerRadius
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let playlistImageSize: CGFloat = height / 1.8
        playlistImageView.frame = CGRect(
            x: (width - playlistImageSize) / 2,
            y: 20,
            width: playlistImageSize,
            height: playlistImageSize
        )
        
        nameLabel.frame = CGRect(
            x: Constants.labelPositionX,
            y: playlistImageView.bottom,
            width: width - Constants.labelWidthPadding,
            height: Constants.labelHeight
        )
        descriptionLabel.frame = CGRect(
            x: Constants.labelPositionX,
            y: nameLabel.bottom,
            width: width - Constants.labelWidthPadding,
            height: Constants.labelHeight
        )
        ownerLabel.frame = CGRect(
            x: Constants.labelPositionX,
            y: descriptionLabel.bottom,
            width: width - Constants.labelWidthPadding,
            height: Constants.labelHeight
        )
        
        playAllButton.frame = CGRect(
            x: width - Constants.playAllButtonPadding,
            y: height - Constants.playAllButtonPadding,
            width: Constants.playAllButtonSize,
            height: Constants.playAllButtonSize
        )
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(
            with: viewModel.artworkURL,
            placeholderImage: UIImage(systemName: "photo")
        )
    }
    
    @objc private func didTapPlayAll() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
}
