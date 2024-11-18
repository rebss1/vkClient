//
//  AuthView.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import UIKit
import SnapKit

protocol AuthViewDelegate: AnyObject {
    func didAuthetificate(_ vc: AuthViewController, didAuthenticateWithQueryItems items: [URLQueryItem])
}

final class AuthViewController: UIViewController {
    
    // MARK: - Public Propeerties

    weak var delegate: AuthViewDelegate?
    
    // MARK: - UI

    private let authButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(AuthViewController.self,
                         action: #selector(didTapAuthButton),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - WebViewDelegate

extension AuthViewController: WebViewDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithQueryItems queryItems: [URLQueryItem]) {
        delegate?.didAuthetificate(self, didAuthenticateWithQueryItems: queryItems)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Private Methods

private extension AuthViewController {
    
    @objc
    func didTapAuthButton() {
        let presenter = WebPresenterImpl()
        let viewController = WebViewController(presenter: presenter)
        presenter.view = viewController
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setUp() {
        view.addSubview(authButton)
        view.backgroundColor = .white
        
        authButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(80)
        }
    }
}
