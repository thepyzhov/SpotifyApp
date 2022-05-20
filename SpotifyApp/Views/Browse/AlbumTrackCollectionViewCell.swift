//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 06.05.2022.
//

import UIKit

private enum Constants {
    static let trackNameLabelFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    static let artistNameLabelFont = UIFont.systemFont(ofSize: 15, weight: .thin)
        
    static let nameLabelXPadding: CGFloat = 10
    static let nameLabelWidthPadding: CGFloat = 15
}

class AlbumTrackCollectionViewCell: UICollectionViewCell, Reusable {
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.frame = CGRect(
            x: Constants.nameLabelXPadding,
            y: 0,
            width: contentView.width - Constants.nameLabelWidthPadding,
            height: contentView.height / 2
        )
        artistNameLabel .frame = CGRect(
            x: Constants.nameLabelXPadding,
            y: contentView.height / 2,
            width: contentView.width - Constants.nameLabelWidthPadding,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}

