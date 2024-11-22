//
//  DetailsPresenter.swift
//  vkClient
//
//  Created by Илья Лощилов on 21.11.2024.
//

import Foundation

protocol DetailsPresenter: AnyObject {
    func changeLike(completion: @escaping () -> Void)
    func getPhotosCount() -> Int
    func configure(with header: DetailsCollectionHeader)
    func configure(with cell: DetailsCollectionCell, indexPath: IndexPath)
    var isEmptyHeaderText: Bool { get }
}

final class DetailsPresenterImpl {
    
    //MARK: - Public properties
    
    weak var view: DetailsView?
    var isEmptyHeaderText: Bool {
        model.text.isEmpty
    }
    
    //MARK: - Private Properties
    
    private var model: FeedCellModel
    private let service = LikeService()
    private let storage = Storage()
    
    //MARK: - Initialization

    init(model: FeedCellModel) {
        self.model = model
    }
}

//MARK: - DetailsPresenter

extension DetailsPresenterImpl: DetailsPresenter {
    
    func configure(with header: DetailsCollectionHeader) {
        isLiked() {
            header.configure(with: self.model)
        }
    }
    
    func configure(with cell: DetailsCollectionCell,
                   indexPath: IndexPath) {
        let photos = model.photos[indexPath.row]
        cell.configure(with: photos)
    }
    
    func changeLike(completion: @escaping () -> Void) {
        guard let accessToken = storage.accessToken else { return }
        if model.canLike {
            service.isLiked(with: accessToken,
                                          type: "post",
                                          itemId: model.postId,
                                          ownerId: model.ownerId) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let likeModel):
                    let isLiked = likeModel.liked != 0
                    if isLiked {
                        service.deleteLike(with: accessToken,
                                           type: "post",
                                           itemId: self.model.postId,
                                           ownerId: self.model.ownerId) {
                            self.model.isLiked = !isLiked
                            completion()
                        }
                    } else {
                        service.addLike(with: accessToken,
                                        type: "post",
                                        itemId: model.postId,
                                        ownerId: model.ownerId) {
                            self.model.isLiked = !isLiked
                            completion()
                        }
                    }
                case .failure(let error):
                    let model = makeErrorModel(error)
                    view?.showError(model)
                }
            }
        } else {
            let model = makeErrorModel(from: "You can't do this")
            view?.showError(model)
        }
    }
    
    func getPhotosCount() -> Int {
        let count = model.photos.count
        if count == 0 {
            let model = makeErrorModel(from: "There is no photo here")
            view?.showError(model)
        }
        return count
    }
}

//MARK: - Private properties

private extension DetailsPresenterImpl {
    
    func isLiked(completion: @escaping () -> Void) {
        if let accessToken = storage.accessToken {
            service.isLiked(with: accessToken,
                            type: "post",
                            itemId: model.postId,
                            ownerId: model.ownerId) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let likeModel):
                    model.isLiked = likeModel.liked == 1
                    completion()
                case .failure(let error):
                    let model = makeErrorModel(error)
                    view?.showError(model)
                }
            }
        }
    }

    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message = error.localizedDescription
        let actionText = "Ok"
        return ErrorModel(message: message, actionText: actionText) { }
    }
    
    func makeErrorModel(from string: String) -> ErrorModel {
        let message = string
        let actionText = "Ok"
        return ErrorModel(message: message, actionText: actionText) { }
    }
}
