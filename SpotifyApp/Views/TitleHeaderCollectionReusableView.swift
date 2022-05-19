//
//  TitleHeaderCollectionReusableView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 05.05.2022.
//

import UIKit

private enum Constants {
    static let labelFont = UIFont.systemFont(ofSize: 22, weight: .bold)
    static let labelPositionX: CGFloat = 10
    static let labelPositionY: CGFloat = 0
    static let labelWidthPadding: CGFloat = 20
}

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = Constants.labelFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: Constants.labelPositionX,
            y: Constants.labelPositionY,
            width: width - Constants.labelWidthPadding,
            height: height
        )
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
