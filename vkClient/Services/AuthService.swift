//
//  AuthService.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import Alamofire
import Foundation

final class AuthService {
    
    func makeAuthRequest() -> URLRequest? {
        guard let url = URL(string: AC.baseUrl) else { return nil}
        return URLRequest(url: url)
    }
    
    func fetchAccessToken(with code: String,
                          deviceId: String,
                          completion: @escaping (Result<AuthTokenModel, Error>) -> Void) {
        let params = ["grant_type" : "authorization_code",
                      "code_verifier" : "AcEn66qHzvyruf0hGU9Q04mHAaWjSqtviyGqkyuWPjo",
                      "redirect_uri" : "vk52704223://vk.com/blank.html",
                      "code" : code,
                      "client_id" : "52704223",
                      "device_id" : deviceId,
                      "state": "abracadabracode"]
        AF.request(AC.oauthUrl,
                   method: .post,
                   parameters: params)
        .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tokenModel = try decoder.decode(
                        AuthTokenModel.self,
                        from: data
                    )
                    completion(.success(tokenModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshAccessToken(with refreshToken: String,
                            deviceId: String,
                            completion: @escaping (Result<AuthTokenModel, Error>) -> Void) {
        let queryItems = ["grant_type" : "refresh_token",
                          "client_id" : AC.clientId,
                          "device_id" : deviceId]
        let bodyParams = ["refresh_token" : refreshToken]
        
        AF.request(AC.oauthUrl,
                   method: .post,
                   parameters: bodyParams)
        .querryParameters(queryItems)
        .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tokenModel = try decoder.decode(
                        AuthTokenModel.self,
                        from: data
                    )
                    completion(.success(tokenModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
