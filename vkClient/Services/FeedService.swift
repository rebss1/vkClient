//
//  FeedService.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation
import Alamofire

final class FeedService {
    
    func fetchFeed(with accessToken: String,
                   startFrom: String,
                   completion: @escaping (Result<FeedResponseModel, Error>) -> Void) {
        var params = ["v" : "5.199",
                      "access_token" : accessToken,
                      "filters" : "post",
                      "count" : "10"]
        if !startFrom.isEmpty {
            params.updateValue(startFrom, forKey: "start_from")
        }
        
        AF.request(FC.feedUrl,
                   method: .get)
        .querryParameters(params)
        .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                    
                    let feedModel = try decoder.decode(
                        FeedResponseModel.self,
                        from: data
                    )
                    completion(.success(feedModel))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(with accessToken: String,
                completion: @escaping () -> Void) {
        let params = ["client_id" : AC.clientId]
        let headers = HTTPHeaders(
            dictionaryLiteral: ("Authorization", "Bearer \(accessToken)"))
        
        AF.request(FC.logoutUrl,
                   method: .get,
                   headers: headers)
        .querryParameters(params)
        .response { response in
            switch response.result {
            case .success(let data):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
