//
//  SearchResultSubtitleTableViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 11.05.2022.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell, Reusable {    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        
        let labelHeight = contentView.height / 2
        label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width - iconImageView.right - 15, height: labelHeight)
        subtitleLabel.frame = CGRect(x: iconImageView.right + 10, y: label.bottom, width: contentView.width - iconImageView.right - 15, height: labelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"))
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
