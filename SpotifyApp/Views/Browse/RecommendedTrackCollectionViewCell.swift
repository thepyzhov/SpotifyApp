//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 26.04.2022.
//

import UIKit
import SDWebImage

private enum Constants {
    static let trackNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let artistNameLabelFont = UIFont.systemFont(ofSize: 15, weight: .thin)
    
    static let albumCoverImageViewXPadding: CGFloat = 5
    static let albumCoverImageViewYPadding: CGFloat = 2
    static let albumCoverImageViewHeightPadding: CGFloat = 4
    static let albumCoverImageViewWidthPadding: CGFloat = 4
    
    static let nameLabelXPadding: CGFloat = 10
    static let nameLabelWidthPadding: CGFloat = 15
}

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.trackNameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.artistNameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(
            x: Constants.albumCoverImageViewXPadding,
            y: Constants.albumCoverImageViewYPadding,
            width: contentView.height - Constants.albumCoverImageViewHeightPadding,
            height: contentView.height - Constants.albumCoverImageViewWidthPadding
        )
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + Constants.nameLabelXPadding,
            y: 0,
            width: contentView.width - albumCoverImageView.right - Constants.nameLabelWidthPadding,
            height: contentView.height / 2
        )
        artistNameLabel .frame = CGRect(
            x: albumCoverImageView.right + Constants.nameLabelXPadding,
            y: contentView.height / 2,
            width: contentView.width - albumCoverImageView.right - Constants.nameLabelWidthPadding,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
        artistNameLabel.text = viewModel.artistName
    }
}
