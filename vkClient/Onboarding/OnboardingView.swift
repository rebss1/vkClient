//
//  OnboardingView.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private Properties

    private let storage = Storage()
    private let service = AuthService()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.accessToken {
            refreshAccessToken()
        } else {
            switchToAuth()
        }
    }
}

// MARK: - AuthViewDelegate

extension OnboardingViewController: AuthViewDelegate {
    
    func didAuthetificate(_ vc: AuthViewController, didAuthenticateWithQueryItems items: [URLQueryItem]) {
        vc.dismiss(animated: true)
        fetchAccessToken(with: items)
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {
    
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
                    case .failure:
                        break
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
                case .failure:
                    break
                }
            }
        }
    }
    
    func switchToAuth() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func switchToFeed() {
        let feedPresenter = FeedPresenterImpl()
        let feedViewController = FeedViewController(presenter: feedPresenter)
        feedPresenter.view = feedViewController
        let navigationController = UINavigationController(rootViewController: feedViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func setUp() {
        view.backgroundColor = .red
    }
}
