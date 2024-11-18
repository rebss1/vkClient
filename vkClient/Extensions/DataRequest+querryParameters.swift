//
//  DataRequest+querryParameters.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import Alamofire
import Foundation

extension DataRequest {
    func querryParameters(_ parameters: [String: String]) -> DataRequest {
        guard var urlRequest = self.convertible.urlRequest else { return self }
        
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        if let urlWithQuery = urlComponents?.url {
            urlRequest.url = urlWithQuery
        }
        
        return AF.request(urlRequest)
    }
}
