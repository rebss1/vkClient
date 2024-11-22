//
//  DetailsCollectionHeader.swift
//  vkClient
//
//  Created by Илья Лощилов on 21.11.2024.
//

import UIKit
import Kingfisher
import SnapKit

protocol DetailsCollectionHeaderDelegate: AnyObject {
    func changeLike()
}

final class DetailsCollectionHeader: UICollectionViewCell {
    
    // MARK: - Constants
    
    static var defaultReuseIdentifier = "DetailsCollectionHeader"
    
    // MARK: - Public Properties

    weak var delegate: DetailsCollectionHeaderDelegate?
    
    // MARK: - UI
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 50
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self,
                         action: #selector(didTapLikeButton),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Public Methods
    
    func configure(with cellModel: FeedCellModel) {
        coverImageView.kf.setImage(with: URL(string: cellModel.coverImageUrl))
        nameLabel.text = cellModel.name
        textLabel.text = cellModel.text
        let likeImage = cellModel.isLiked ? "likeOn" : "likeOff"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
    }
}
    
// MARK: - Private Methods
    
private extension DetailsCollectionHeader {
    
    @objc
    func didTapLikeButton() {
        delegate?.changeLike()
    }
    
    func setUp() {
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .customBlue
        
        [coverImageView, nameLabel, textLabel, likeButton].forEach { view in
            contentView.addSubview(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
    }
}
