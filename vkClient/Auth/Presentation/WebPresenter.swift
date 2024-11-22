//
//  AuthPresenter.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import Foundation

protocol WebPresenter: AnyObject {
    func viewDidLoad()
    func queryItems(from url: URL) -> [URLQueryItem]?
}

final class WebPresenterImpl {
    
    weak var view: WebView?
    
    //MARK: - Private properties
    
    private let authService = AuthService()
}

extension WebPresenterImpl: WebPresenter {
    
    func viewDidLoad() {
        guard let request = authService.makeAuthRequest() else { return }
        view?.load(with: request)
    }
    
    func queryItems(from url: URL) -> [URLQueryItem]? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           let items = urlComponents.queryItems,
           let code = items.first(where: { $0.name == "code" }) {
            return items
        } else {
            return nil
        }
    }
}
