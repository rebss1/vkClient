//
//  OnboardingPresenter.swift
//  vkClient
//
//  Created by Илья Лощилов on 22.11.2024.
//

import Foundation
import UIKit

protocol OnboardingPresenter: AnyObject {
    func didAuthetificate(_ vc: AuthViewController,
                        didAuthenticateWithQueryItems items: [URLQueryItem])
    func viewDidApper()
}

final class OnboardingPresenterImpl {
    
    // MARK: - Public Properties

    weak var view: OnboardingView?
    
    // MARK: - Private Properties

    private let storage = Storage()
    private let service = AuthService()
}

extension OnboardingPresenterImpl: OnboardingPresenter {
    
    func didAuthetificate(_ vc: AuthViewController,
                        didAuthenticateWithQueryItems items: [URLQueryItem]) {
        vc.dismiss(animated: true)
        fetchAccessToken(with: items)
    }
    
    func viewDidApper() {
        if let token = storage.accessToken {
            refreshAccessToken()
        } else {
            switchToAuth()
        }
    }
}

private extension OnboardingPresenterImpl {
    
    func fetchAccessToken(with items: [URLQueryItem]) {
        if let deviceId = items.first(where: { $0.name == "device_id" }),
           let code = items.first(where: { $0.name == "code" }) {
            guard
                let code = code.value,
                let deviceId = deviceId.value
            else { return }
            service.fetchAccessToken(with: code,
                                     deviceId: deviceId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tokenModel):
                        let accessToken = tokenModel.accessToken
                        let refreshToken = tokenModel.refreshToken
                        self?.storage.store(token: accessToken, for: .access)
                        self?.storage.store(token: refreshToken, for: .refresh)
                        self?.storage.store(token: deviceId, for: .deviceId)
                        self?.switchToFeed()
                    case .failure(let error):
                        if let model = self?.makeErrorModel(error) {
                            self?.view?.showError(model)
                        }
                    }
                }
            }
        }
    }
    
    func refreshAccessToken() {
        guard
            let refreshToken = storage.refreshToken,
            let deviceId = storage.deviceId
        else { return }
        service.refreshAccessToken(with: refreshToken,
                                   deviceId: deviceId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenModel):
                    let accessToken = tokenModel.accessToken
                    let refreshToken = tokenModel.refreshToken
                    self?.storage.store(token: accessToken, for: .access)
                    self?.storage.store(token: refreshToken, for: .refresh)
                    self?.storage.store(token: deviceId, for: .deviceId)
                    self?.switchToFeed()
                case .failure(let error):
                    if let model = self?.makeErrorModel(error) {
                        self?.view?.showError(model)
                    }
                }
            }
        }
    }
    
    func switchToAuth() {
        let authViewController = AuthViewController()
        authViewController.delegate = view
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        view?.present(navigationController)
    }
    
    func switchToFeed() {
        let feedPresenter = FeedPresenterImpl()
        let feedViewController = FeedViewController(presenter: feedPresenter)
        feedPresenter.view = feedViewController
        let navigationController = UINavigationController(rootViewController: feedViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        view?.present(navigationController)
    }
    
    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message = error.localizedDescription
        let actionText = "Ok"
        return ErrorModel(message: message, actionText: actionText) { }
    }
}
