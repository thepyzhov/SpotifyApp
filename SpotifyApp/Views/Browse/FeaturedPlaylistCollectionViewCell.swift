//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 26.04.2022.
//

import UIKit
import SDWebImage

private enum Constants {
    static let playlistNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let creatorNameLabelFont = UIFont.systemFont(ofSize: 15, weight: .thin)
    
    static let playlistCoverImageViewCornerRadius: CGFloat = 4
    static let playlistCoverImageViewYPadding: CGFloat = 3
    
    static let creatorNameLabelHeight: CGFloat = 30
    static let playlistNameLabelHeight: CGFloat = 30
    static let nameLabelXPadding: CGFloat = 3
    static let nameLabelHeightPadding: CGFloat = 30
    static let nameLabelWidthPadding: CGFloat = 6
    static let imageSizePadding: CGFloat = 70
}

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell, Reusable {    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.playlistCoverImageViewCornerRadius
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.playlistNameLabelFont
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.creatorNameLabelFont
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorNameLabel.frame = CGRect(
            x: Constants.nameLabelXPadding,
            y: contentView.height - Constants.nameLabelHeightPadding,
            width: contentView.width - Constants.nameLabelWidthPadding,
            height: Constants.creatorNameLabelHeight
        )
        playlistNameLabel.frame = CGRect(
            x: Constants.nameLabelXPadding,
            y: contentView.height - Constants.nameLabelHeightPadding * 2,
            width: contentView.width - Constants.nameLabelWidthPadding,
            height: Constants.playlistNameLabelHeight
        )
        
        let imageSize = contentView.height - Constants.imageSizePadding
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: Constants.playlistCoverImageViewYPadding,
            width: imageSize,
            height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL)
        creatorNameLabel.text = viewModel.creatorName
    }
}
