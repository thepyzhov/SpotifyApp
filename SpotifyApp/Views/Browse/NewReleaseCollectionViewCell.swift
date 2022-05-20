//
//  NewReleaseCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 26.04.2022.
//

import UIKit
import SDWebImage

private enum Constants {
    static let albumNameLabelFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let artistNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .light)
    static let numberOfTracksLabelFont = UIFont.systemFont(ofSize: 18, weight: .thin)
    
    static let contentViewPadding: CGFloat = 10

    static let albumCoverImageViewPadding: CGFloat = 5
    static let albumNameLabelPadding: CGFloat = 5
    static let albumNameLabelMinHeight: CGFloat = 60
    static let artistNameLabelHeight: CGFloat = 30
    static let numberOfTracksLabelHeight: CGFloat = 44
}

class NewReleaseCollectionViewCell: UICollectionViewCell, Reusable {
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.albumNameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.artistNameLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.numberOfTracksLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - Constants.contentViewPadding
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - Constants.contentViewPadding,
                height: contentView.height - Constants.contentViewPadding
            )
        )
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(
            x: Constants.albumCoverImageViewPadding,
            y: Constants.albumCoverImageViewPadding,
            width: imageSize,
            height: imageSize
        )
        
        let albumNameLabelHeight = min(Constants.albumNameLabelMinHeight, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + Constants.contentViewPadding,
            y: Constants.albumNameLabelPadding,
            width: albumLabelSize.width,
            height: albumNameLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + Constants.contentViewPadding,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right - Constants.contentViewPadding,
            height: Constants.artistNameLabelHeight
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + Constants.contentViewPadding,
            y: contentView.bottom - Constants.numberOfTracksLabelHeight,
            width: numberOfTracksLabel.width,
            height: Constants.numberOfTracksLabelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
