//
//  AuthConstants.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

typealias AC = AuthConstants

enum AuthConstants {
    static let state = "abracadabracode"
    static let clientId = "52704223"
    static let baseUrl = "https://id.vk.com/authorize?state=abracadabra&response_type=code&code_challenge=YanL0lfvqnbiqSu64HM6iL-j2qfNK_CM4h6HOabC-b0&code_challenge_method=S256&client_id=52704223&redirect_uri=vk52704223://vk.com/blank.html&prompt=login&scope=phone%20email%20friends%20wall"
    static let oauthUrl = "https://id.vk.com/oauth2/auth"
}

