//
//  DetailsCollectionCell.swift
//  vkClient
//
//  Created by Илья Лощилов on 21.11.2024.
//

import UIKit
import Kingfisher
import SnapKit

final class DetailsCollectionCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static var defaultReuseIdentifier = "DetailsCollectionCell"
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
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
    
    func configure(with photoUrl: String) {
        guard let url = URL(string: photoUrl) else { return }
        imageView.kf.setImage(with: url)
    }
}
    
    // MARK: - Private Methods
    
private extension DetailsCollectionCell {
    
    func setUp() {
        contentView.layer.cornerRadius = 15

        contentView.addSubview(imageView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
