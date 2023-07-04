//
//  UserDefaults.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/26/22.
//

import Foundation


/// UserDefaults extension:
/// Extending the userdefaults so that all the methods including set token , remove token and etc can be accessed all over the app
/// in a clean way, Using an enum to add all the cases that are needed to be cached on the device using their raw value (since the key is a string)
extension UserDefaults {

    
    //MARK: Check Login
     func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
     func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    
    
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
    
    //MARK: Language
    func setLanguage(value: String) {
        set(value, forKey: UserDefaultsKeys.language.rawValue)
    }
    
    func getLanguage() -> String {
        return self.string(forKey: UserDefaultsKeys.language.rawValue) ?? "english"
    }
    
    //MARK: Calendar
    func setCalendarType(value: String) {
        set(value, forKey: UserDefaultsKeys.calendarType.rawValue)
    }
    
    
    func getCalendarType() -> String {
        return self.string(forKey: UserDefaultsKeys.calendarType.rawValue) ?? "gregorian"
    }
    
    //MARK: Biometrics
    func setBiometricStatus(value: Bool) {
        set(value, forKey: UserDefaultsKeys.hasBiometric.rawValue)
    }
    
    func getBiometricStatus() -> Bool {
        bool(forKey: UserDefaultsKeys.hasBiometric.rawValue)
    }
    
    //MARK: Passcode
    func setPasscodeStatus(value: Bool) {
        set(value, forKey: UserDefaultsKeys.hasPasscode.rawValue)
    }
    
    func getPasscodeStatus() -> Bool {
        bool(forKey: UserDefaultsKeys.hasPasscode.rawValue)
    }
    
    func setPasscode(value: String) {
        set(value, forKey: UserDefaultsKeys.passcode.rawValue)
    }
    
    func getPasscode() -> String {
        string(forKey: UserDefaultsKeys.passcode.rawValue) ?? ""
    }
    
    func erasePasscode() {
        set("", forKey: UserDefaultsKeys.passcode.rawValue)
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
