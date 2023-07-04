//
//  Date+Start&EndOfWeek.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/5/22.
//

import Foundation

extension Date {
    
    
    func startOfCurrentWeek() -> Date {
        let calendarType = LocalizationService.shared.calendarType
        
        var calendar = Calendar(identifier: calendarType.rawValue == "Jalali" ? .persian : .gregorian)
        
        calendar.firstWeekday = calendarType == .jalali ? 7 : 0
        
        if calendarType == .jalali {
            return (calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))?.adding(.day, value: 0))!
        } else {
            return (calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)))!
        }
        
        
        
        

    }
    
    func endOfCurrentWeek() -> Date {
        
        let calendarType = LocalizationService.shared.calendarType
        
        var calendar = Calendar(identifier: calendarType.rawValue == "Jalali" ? .persian : .gregorian)
        
        calendar.firstWeekday = calendarType == .jalali ? 7 : 0
        
        return calendar.date(byAdding: DateComponents(day: 6), to: self.startOfCurrentWeek())!
    }
    
    
}
