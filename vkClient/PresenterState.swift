//
//  PresenterState.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

enum PresenterState {
    case initial
    case loading
    case failed(Error)
    case data
}
