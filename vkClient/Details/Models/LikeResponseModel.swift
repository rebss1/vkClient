//
//  LikeResponseModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 22.11.2024.
//

struct LikeResponseModel: Decodable {
    let response: LikeResponse
}

struct LikeResponse: Decodable {
    let liked: Int
}
