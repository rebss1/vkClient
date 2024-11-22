//
//  FeedCellModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation

struct FeedCellModel {
    let coverImageUrl: String
    let name: String
    let date: String
    let text: String
    let photos: [String]
    var isLiked: Bool
    let canLike: Bool
    let ownerId: Int
    let postId: Int
    
    init(coverImageUrl: String,
         name: String,
         date: String,
         text: String,
         photos: [String],
         isLiked: Bool,
         canLike: Bool,
         ownerId: Int,
         postId: Int) {
        self.coverImageUrl = coverImageUrl
        self.name = name
        self.date = date
        self.text = text
        self.photos = photos
        self.isLiked = isLiked
        self.canLike = canLike
        self.ownerId = ownerId
        self.postId = postId
    }
    
    init(from model: FeedResponseModel, with item: Item) {
        let ownerId = item.ownerId
        if ownerId > 0 {
            let profile = model.response.profiles.first(where: { $0.id == ownerId})
            self.coverImageUrl = profile?.photo50 ?? ""
            self.name = "\(String(describing: profile?.firstName ?? "")) \(String(describing: profile?.lastName ?? ""))"
        } else {
            let group = model.response.groups.first(where: { $0.id == -ownerId})
            self.coverImageUrl = group?.photo50 ?? ""
            self.name = "\(String(describing: group?.name ?? ""))"
        }
        
        let date = Date(timeIntervalSince1970: item.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formattedDate = dateFormatter.string(from: date)
        self.date = formattedDate
        
        self.text = item.text ?? ""
        
        var photos: [String] = []
        if let attachments = item.attachments {
            for attachment in attachments {
                if let photo = attachment.photo?.origPhoto.url {
                    photos.append(photo)
                }
            }
        }
        self.photos = photos
        self.isLiked = item.isFavorite
        if let likes = item.likes {
            self.canLike = likes.canLike == 1 ? true : false
        } else {
            self.canLike = false
        }
        self.ownerId = item.ownerId
        self.postId = item.postId
    }
}
