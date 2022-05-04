//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 04.05.2022.
//

import UIKit
import SDWebImage

private enum Constants {
    static let nameLabelFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let ownerLabelFont = UIFont.systemFont(ofSize: 18, weight: .light)
    
    static let labelHeight: CGFloat = 44
    static let labelWidthPadding: CGFloat = 20
    static let labelPositionX: CGFloat = 10
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let playlistImageSize: CGFloat = height / 1.8
        playlistImageView.frame = CGRect(x: (width - playlistImageSize) / 2, y: 20, width: playlistImageSize, height: playlistImageSize)
        
        nameLabel.frame = CGRect(x: Constants.labelPositionX, y: playlistImageView.bottom, width: width - Constants.labelWidthPadding, height: Constants.labelHeight)
        descriptionLabel.frame = CGRect(x: Constants.labelPositionX, y: nameLabel.bottom, width: width - Constants.labelWidthPadding, height: Constants.labelHeight)
        ownerLabel.frame = CGRect(x: Constants.labelPositionX, y: descriptionLabel.bottom, width: width - Constants.labelWidthPadding, height: Constants.labelHeight)
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
