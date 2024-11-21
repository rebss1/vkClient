//
//  FeedCell.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static var defaultReuseIdentifier = "FeedCell"
    
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
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
        dateLabel.text = cellModel.date
    }
}
    
// MARK: - Private Methods
    
private extension FeedCell {
    
    func setUp() {
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .lightGray
        
        [coverImageView, nameLabel, dateLabel].forEach { view in
            contentView.addSubview(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(coverImageView.snp.height)
        }
                
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(10)
        }
    }
}
