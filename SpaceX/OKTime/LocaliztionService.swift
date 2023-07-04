//
//  LocaliztionService.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/13/22.
//

import Foundation

/// Localization Service includes the calendar type and the language
/// both which are set by the user
/// if any of those changes ( set ) the new value would be set to userdefaults to cache it on the device
/// It uses singleton so that can be used all over the app when needed 
class LocalizationService {
    
    
    
    static let shared = LocalizationService()
    
    static let changedLanguage = Notification.Name("changedLanguage")
    
    static let changedCalendar = Notification.Name("changedCalendar")
    
    private init() {}
    
    var language: Language {
        
        
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english
            }
            return Language(rawValue: languageString) ?? .english
        }
        
        set {
            if newValue != language {
                UserDefaults.standard.setLanguage(value: newValue.rawValue)
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
        
        
    }
    
    var calendarType: CalendarLocal {
        
        
        get {
            guard let calendarString = UserDefaults.standard.string(forKey: "calendar") else {
                return .georgian
            }
            
            return CalendarLocal(rawValue: calendarString) ?? .georgian
        }
        
        set {
            if newValue != calendarType {
                
                UserDefaults.standard.set(newValue.rawValue, forKey: "calendar")
                NotificationCenter.default.post(name: LocalizationService.changedCalendar, object: nil)
            }
        }
        
        
        
    }
    
    
}
