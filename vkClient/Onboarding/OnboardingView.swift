//
//  OnboardingView.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import UIKit
import SnapKit

protocol OnboardingView: AnyObject, ErrorView, LoadingView, AuthViewDelegate {
    func present(_ viewController: UIViewController)
}

final class OnboardingViewController: UIViewController {
    
    // MARK: - Public Properties

    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties

    private let presenter: OnboardingPresenter
    
    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization

    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidApper()
    }
}

// MARK: - OnboardingView

extension OnboardingViewController: OnboardingView {
    
    func didAuthetificate(_ vc: AuthViewController,
                          didAuthenticateWithQueryItems items: [URLQueryItem]) {
        presenter.didAuthetificate(vc, didAuthenticateWithQueryItems: items)
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {

    func setUp() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
        }
    }
}
