//
//  ItemModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation

// MARK: - Item

struct Item: Decodable {
    let type: String
    let date: TimeInterval
    let attachments: [Attachment]?
    let likes: Likes?
    let ownerId: Int
    let postId: Int
    let text: String?
}

// MARK: - Likes

struct Likes: Decodable {
    let canLike: Int
    let count: Int
    let userLikes: Int
    let canPublish: Int
}

// MARK: - Attachment

struct Attachment: Decodable {
    let type: String
    let photo: Photo?
    let postedPhoto: Empty?
    let video: Empty?
    let audio: Empty?
    let doc: Empty?
    let graffity: Empty?
    let link: Empty?
    let note: Empty?
    let app: Empty?
    let poll: Empty?
    let page: Empty?
    let album: Empty?
    let photosList: Empty?
    let market: Empty?
    let marketAlbum: Empty?
    let sticker: Empty?
    let prettyCard: Empty?
    let event: Empty?
}

// MARK: - Photo

struct Photo: Decodable {
    let id: Int
    let ownerId: Int
    let origPhoto: OrigPhoto
}

// MARK: - OrigPhoto

struct OrigPhoto: Decodable {
    let url: String
}

// MARK: - Empty

struct Empty: Decodable { }
