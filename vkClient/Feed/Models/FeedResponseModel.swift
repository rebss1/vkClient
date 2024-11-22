//
//  FeedResponseModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation

struct FeedResponseModel: Decodable {
    let response: Response
}

struct Response: Decodable {
    let items: [Item]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String
}
