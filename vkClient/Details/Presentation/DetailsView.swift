//
//  DetailsView.swift
//  vkClient
//
//  Created by Илья Лощилов on 20.11.2024.
//

import UIKit
import SnapKit

protocol DetailsView: AnyObject, ErrorView, LoadingView { }

final class DetailsViewController: UIViewController, DetailsView {
    
    //MARK: - Public Properties

    lazy var activityIndicator = UIActivityIndicatorView()

    //MARK: - Private Properties

    private lazy var collectionWidth = collectionView.frame.width

    private let presenter: DetailsPresenter
    
    //MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailsCollectionHeader.self, forCellWithReuseIdentifier: DetailsCollectionHeader.defaultReuseIdentifier)
        collectionView.register(DetailsCollectionCell.self, forCellWithReuseIdentifier: DetailsCollectionCell.defaultReuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "chevron.backward"),
                                  for: .normal)
        button.tintColor = .black
        button.addTarget(self,
                         action: #selector(didTapBackButton),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initializers

    init(presenter: DetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return presenter.getPhotosCount()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard
                let header = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionHeader.defaultReuseIdentifier, for: indexPath) as? DetailsCollectionHeader
            else { return UICollectionViewCell() }
            header.delegate = self
            presenter.configure(with: header)
            return header
        default:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionCell.defaultReuseIdentifier, for: indexPath) as? DetailsCollectionCell
            else { return UICollectionViewCell() }
            presenter.configure(with: cell, indexPath: indexPath)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionWidth - 2 * DetailsLayoutConstants.headerInsets.left
        var headerHeight: CGFloat = 250
        switch indexPath.section {
        case 0:
            if presenter.isEmptyHeaderText {
                headerHeight = 120
            }
            return CGSize(width: width,
                          height: headerHeight)
        default:
            return CGSize(width: width,
                          height: width)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        switch section {
        case 0:
            return DetailsLayoutConstants.headerInsets
        default:
            return DetailsLayoutConstants.cellInsets
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DetailsLayoutConstants.minimumInteritemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return DetailsLayoutConstants.minimumLineSpacing
    }
}

// MARK: - UICollectionViewDelegate

extension DetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
}

// MARK: - DetailsCollectionHeaderDelegate

extension DetailsViewController: DetailsCollectionHeaderDelegate {
    
    func changeLike() {
        presenter.changeLike() {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

// MARK: - Private Methods

private extension DetailsViewController {
    
    @objc
    func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(backButton)
        view.addSubview(activityIndicator)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

