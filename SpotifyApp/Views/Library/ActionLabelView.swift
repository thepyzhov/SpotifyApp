//
//  ActionLabelView.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 16.05.2022.
//

import UIKit

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubviews()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: width, height: height - 45)
        button.frame = CGRect(x: 0, y: height - 40, width: width, height: 40)
    }
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    private func addSubviews() {
        [button, label].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Buttons Selectors
    
    @objc private func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
}
