//
//  FeedView.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import UIKit
import SnapKit

protocol FeedView: AnyObject, ErrorView, LoadingView {
    func present(_ viewController: UIViewController)
    func displayCells(_ cellModels: [FeedCellModel])
    func dismiss(controller: UIViewController)
}

final class FeedViewController: UIViewController {
    
    //MARK: - Private Properties

    private lazy var collectionWidth = collectionView.frame.width
    lazy var activityIndicator = UIActivityIndicatorView()

    private var cellModels: [FeedCellModel] = []
    private let presenter: FeedPresenter
    
    //MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.defaultReuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "iphone.and.arrow.right.outward"), for: .normal)
        button.tintColor = .red
        button.addTarget(self,
                         action: #selector(didTapLogoutButton),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initializers

    init(presenter: FeedPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.defaultReuseIdentifier, for: indexPath) as? FeedCell
        else { return UICollectionViewCell() }
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        presenter.fetchNextPosts(indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionWidth - 2 * FeedLayoutConstants.insets.left,
                      height: FeedLayoutConstants.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return FeedLayoutConstants.insets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return FeedLayoutConstants.minimumInteritemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return FeedLayoutConstants.minimumLineSpacing
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openDetails(with: cellModels[indexPath.row])
    }
}

// MARK: - MainView

extension FeedViewController: FeedView {
    
    func dismiss(controller: UIViewController) {
        controller.dismiss(animated: true)
    }
    
    func displayCells(_ cellModels: [FeedCellModel]) {
        self.cellModels = cellModels
        collectionView.reloadData()
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

private extension FeedViewController {
    
    @objc
    func didTapLogoutButton() {
        presenter.showLogoutPopUp()
    }
    
    func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(logoutButton)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
