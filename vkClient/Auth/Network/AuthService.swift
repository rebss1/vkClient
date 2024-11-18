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
                   method: .post, parameters: params)
        .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let tokenModel = try JSONDecoder().decode(
                        AuthTokenModel.self,
                        from: data
                    )
                    completion(.success(tokenModel))
                    print(tokenModel)
                } catch {
                    completion(.failure(error))
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
