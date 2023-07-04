//
//  JalaliHelper.swift
//  JalaliCalendar
//
//  Created by armin on 2/10/21.
//

import Foundation

class JalaliHelper {
    
    
    var calendarType = LocalizationService.shared.calendarType
    
    static let DayEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        
        return formatter
    }()
    
    static let DayFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        formatter.locale = Locale(identifier: LocalizationService.shared.calendarType == .georgian ? "en" : "fa")
        
        return formatter
    }()
    
    static let DayWeekFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        formatter.locale = Locale(identifier: LocalizationService.shared.calendarType == .georgian ? "en" : "fa")
        
        return formatter
    }()
    
    static let MonthEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        
        return formatter
    }()
    
    static let MonthFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        formatter.locale = Locale(identifier: LocalizationService.shared.calendarType == .georgian ? "en" : "fa")
        
        return formatter
    }()
    
    static let YearFa: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: LocalizationService.shared.calendarType == .georgian ? .gregorian : .persian)
        formatter.locale = Locale(identifier: LocalizationService.shared.calendarType == .georgian ? "en" : "fa")
        
        return formatter
    }()
}
