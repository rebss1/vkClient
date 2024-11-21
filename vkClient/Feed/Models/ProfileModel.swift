//
//  Profile.swift
//  vkClient
//
//  Created by Илья Лощилов on 18.11.2024.
//

import Foundation

// MARK: - Profile

struct Profile: Decodable {
    let id: Int
    let photo50: String?
    let firstName: String
    let lastName: String?
    
    init(id: Int,
         photo50: String?,
         firstName: String,
         lastName: String?) {
        self.id = id
        self.photo50 = photo50
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init() {
        self.id = 0
        self.photo50 = nil
        self.firstName = ""
        self.lastName = nil
    }
}
