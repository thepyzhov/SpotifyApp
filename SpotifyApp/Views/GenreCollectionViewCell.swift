//
//  CategoryCollectionViewCell.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 08.05.2022.
//

import UIKit
import SDWebImage

private enum Constants {
    static let contentViewCornerRadius: CGFloat = 8
    static let labelFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let defaultImage = UIImage(systemName: "music.note.list", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
}

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = Constants.defaultImage
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Constants.labelFont
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemYellow,
        .systemPurple,
        .systemBrown,
        .systemTeal,
        .systemGreen,
        .systemOrange,
        .systemOrange,
        .systemGray
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = Constants.defaultImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 20, height: contentView.height / 2)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL)
        contentView.backgroundColor = colors.randomElement()
    }
}
