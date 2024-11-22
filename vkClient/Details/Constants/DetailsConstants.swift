//
//  DetailsConstants.swift
//  vkClient
//
//  Created by Илья Лощилов on 21.11.2024.
//

import UIKit

typealias DC = DetailsConstants

enum DetailsLayoutConstants {
    static let cellHeight: CGFloat = 150
    static let headerInsets = UIEdgeInsets(top: 35, left: 8, bottom: 0, right: 8)
    static let cellInsets = UIEdgeInsets(top: 8, left: 8, bottom: 10, right: 8)
    static let minimumInteritemSpacing: CGFloat = 0
    static let minimumLineSpacing: CGFloat = 8
}

enum DetailsConstants {
    static let addLikesUrl = "https://api.vk.com/method/likes.add"
    static let deleteLikesUrl = "https://api.vk.com/method/likes.delete"
    static let isLikedLikesUrl = "https://api.vk.com/method/likes.isLiked"
    
}
