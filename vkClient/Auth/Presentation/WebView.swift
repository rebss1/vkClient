//
//  AuthView.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import UIKit
import WebKit
import SnapKit

protocol WebViewDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithQueryItems queryItems: [URLQueryItem])
    func webViewControllerDidCancel(_ vc: WebViewController)
}

protocol WebView: AnyObject, ErrorView, LoadingView {
    func load(with request: URLRequest)
}

final class WebViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: WebViewDelegate?
    lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Private Properties

    private let presenter: WebPresenter
    
    // MARK: - UI
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        return webView
    }()
    
    // MARK: - Initializers
    
    init(presenter: WebPresenter) {
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
        presenter.viewDidLoad()
    }
}

// MARK: - Public Methods

extension WebViewController: WebView {
    
    func load(with request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let queryItems = queryItems(from: navigationAction) {
            delegate?.webViewController(self, didAuthenticateWithQueryItems: queryItems)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Private Methods

private extension WebViewController {
    
    func queryItems(from navigationAction: WKNavigationAction) -> [URLQueryItem]? {
        if let url = navigationAction.request.url {
            return presenter.queryItems(from: url)
        }
        return nil
    }
    
    func setUp() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
