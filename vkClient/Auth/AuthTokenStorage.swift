//
//  AuthTokenStorage.swift
//  vkClient
//
//  Created by Илья Лощилов on 17.11.2024.
//

import Foundation
import SwiftKeychainWrapper

typealias SK = StorageKeys

enum StorageKeys: String {
    case access
    case refresh
    case deviceId
}

final class Storage {
    var accessToken: String? {
        KeychainWrapper.standard.string(forKey: SK.access.rawValue)
    }
    
    var refreshToken: String? {
        KeychainWrapper.standard.string(forKey: SK.refresh.rawValue)
    }
    
    var deviceId: String? {
        KeychainWrapper.standard.string(forKey: SK.deviceId.rawValue)
    }
    
    func store(token: String?, for key: SK) {
        guard let token else {
            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: key.rawValue)
            guard removeSuccessful else {
                print("error when deleting token")
                return
            }
            return
        }
        KeychainWrapper.standard.set(token, forKey: key.rawValue)
    }
}
