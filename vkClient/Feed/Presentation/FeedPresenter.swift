//
//  FeedPresenter.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation
import UIKit

enum PresenterState {
    case initial
    case loading
    case failed(Error)
    case data([FeedCellModel])
}

protocol FeedPresenter: AnyObject {
    func viewDidLoad()
    func openDetails(with cellModel: FeedCellModel)
    func showLogoutPopUp()
    func fetchNextPosts(indexPath: IndexPath)
}

final class FeedPresenterImpl {
    
    //MARK: - Public properties
    
    weak var view: FeedView?
    
    //MARK: - Private properties
    
    private var cellModels: [FeedCellModel] = []
    private var modelsCount = 0
    private var nextFrom = ""
    private var service = FeedService()
    private var storage = Storage()
    private var state = PresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }
}

// MARK: - Public Methods

extension FeedPresenterImpl: FeedPresenter {
    
    func fetchNextPosts(indexPath: IndexPath) {
        if indexPath.row + 1 == modelsCount {
            fetchFeed()
        }
    }
    
    func showLogoutPopUp() {
        let title = "Logout"
        let alert = UIAlertController(
            title: title,
            message: "Are you sure?",
            preferredStyle: .alert
        )
        let yesButton = UIAlertAction(
            title: "Yes",
            style: UIAlertAction.Style.destructive
        ) {_ in
            self.logout()
            self.view?.dismiss(controller: alert)
        }
        
        let noButton = UIAlertAction(
            title: "No",
            style: UIAlertAction.Style.default
        ) {_ in
            self.view?.dismiss(controller: alert)
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        view?.present(alert)
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
    func openDetails(with cellModel: FeedCellModel) {
//        let viewController = DetailViewController(presenter: self,
//                                                  cellModel: cellModel)
//        viewController.modalPresentationStyle = .pageSheet
//        view?.present(viewController)
    }
}

// MARK: - Private Methods

private extension FeedPresenterImpl {
    
    func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            fetchFeed()
        case .data(let newCellModels):
            view?.hideLoading()
            cellModels.append(contentsOf: newCellModels)
            view?.displayCells(cellModels)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    func fetchFeed() {
        guard let accessToken = storage.accessToken else { return }
        service.fetchFeed(with: accessToken, startFrom: nextFrom) { [weak self] result in
            switch result {
            case .success(let responseModel):
                guard
                    let cellModels = self?.makeCellModels(from: responseModel)
                else { return }
                self?.nextFrom = responseModel.response.nextFrom
                self?.state = .data(cellModels)
                self?.modelsCount += 10
            case .failure(let error):
                self?.state = .failed(error)
                print(error)
            }
        }
    }
    
    func logout() {
        guard let token = storage.accessToken else { return }
        service.logout(with: token) {
            self.storage.store(token: nil, for: .access)
            self.storage.store(token: nil, for: .refresh)
            self.storage.store(token: nil, for: .deviceId)
            self.switchToOnboarding()
        }
    }
    
    func switchToOnboarding() {
        let onboardingViewController = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: onboardingViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        view?.present(navigationController)
    }
    
    func makeCellModels(from model: FeedResponseModel) -> [FeedCellModel]? {
        let items = model.response.items
        var cellModels: [FeedCellModel] = []
        for item in items {
            let cellModel = FeedCellModel(from: model, with: item)
            cellModels.append(cellModel)
        }
        return cellModels
    }
    
    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message = error.localizedDescription
        let actionText = "Repeat"
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
