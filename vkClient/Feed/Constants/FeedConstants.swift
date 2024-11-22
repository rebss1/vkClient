//
//  FeedConstants.swift
//  vkClient
//
//  Created by Илья Лощилов on 20.11.2024.
//

import UIKit

typealias FC = FeedConstants

enum FeedLayoutConstants {
    static let cellHeight: CGFloat = 150
    static let insets = UIEdgeInsets(top: 25, left: 8, bottom: 10, right: 8)
    static let minimumInteritemSpacing: CGFloat = 0
    static let minimumLineSpacing: CGFloat = 8
}

enum FeedConstants {
    static let logoutUrl = "https://id.vk.com/oauth2/logout"
    static let feedUrl = "https://api.vk.com/method/newsfeed.get"
}
