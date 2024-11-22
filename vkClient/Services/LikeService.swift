//
//  LikeService.swift
//  vkClient
//
//  Created by Илья Лощилов on 22.11.2024.
//

import Foundation
import Alamofire

final class LikeService {
    
    func addLike(with accessToken: String,
                 type: String,
                 itemId: Int,
                 ownerId: Int,
                 completion: @escaping () -> Void) {
        let params = ["access_token" : accessToken,
                      "type" : type,
                      "item_id" : "\(itemId)",
                      "v" : "5.199",
                      "owner_id" : "\(ownerId)"]
        
        AF.request(DC.addLikesUrl,
                   method: .get,
                   parameters: params)
        .response { response in
            switch response.result {
            case .success(let data):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteLike(with accessToken: String,
                 type: String,
                 itemId: Int,
                 ownerId: Int,
                 completion: @escaping () -> Void) {
        let params = ["access_token" : accessToken,
                      "type" : type,
                      "item_id" : "\(itemId)",
                      "v" : "5.199",
                      "owner_id" : "\(ownerId)"]
        
        AF.request(DC.deleteLikesUrl,
                   method: .get,
                   parameters: params)
        .response { response in
            switch response.result {
            case .success(let data):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isLiked(with accessToken: String,
                 type: String,
                 itemId: Int,
                 ownerId: Int,
                 completion: @escaping (Result<LikeResponse, Error>) -> Void) {
        let params = ["access_token" : accessToken,
                      "type" : type,
                      "item_id" : "\(itemId)",
                      "v" : "5.199",
                      "owner_id" : "\(ownerId)"]
        
        AF.request(DC.isLikedLikesUrl,
                   method: .get,
                   parameters: params)
        .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let likeModel = try decoder.decode(
                        LikeResponseModel.self,
                        from: data
                    )
                    completion(.success(likeModel.response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
