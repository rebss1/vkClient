//
//  AuthTokenModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import Foundation

struct AuthTokenModel: Codable {
    let refreshToken: String?
    let accessToken: String?
    let idToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let userID: Int?
    let state: String?
    let scope: String?

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case idToken = "id_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userID = "user_id"
        case state
        case scope
    }
}
