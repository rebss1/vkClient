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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let authButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self,
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
        view.addSubview(imageView)
        view.addSubview(authButton)
        view.backgroundColor = .white
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
        }
        
        authButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.equalTo(190)
            make.height.equalTo(60)
        }
    }
}
