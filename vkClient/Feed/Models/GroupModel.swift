//
//  GroupModel.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation

// MARK: - Group

struct Group: Decodable {
    let id: Int
    let name: String
    let photo50: String?
    
    init(id: Int,
         name: String,
         photo50: String?) {
        self.id = id
        self.name = name
        self.photo50 = photo50
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.photo50 = nil
    }
}
