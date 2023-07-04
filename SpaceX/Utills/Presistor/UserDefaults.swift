//
//  UserDefaults.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation

extension UserDefaults {
    
    //MARK: Token
    func setToken(value: String) {
        set(value, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func getToken() -> String {
        return self.string(forKey: UserDefaultsKeys.token.rawValue) ?? ""
    }
    
    func removeToken() {
        set("", forKey: UserDefaultsKeys.token.rawValue)
    }
    
}

enum UserDefaultsKeys: String {
    
    case isLoggedIn
    case token
    case hasPasscode
    case passcode
    case hasBiometric
    case language
    case calendarType
    
}
