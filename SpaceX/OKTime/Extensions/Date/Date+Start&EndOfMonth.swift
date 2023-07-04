//
//  Date+Start&EndOfMonth.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/3/22.
//

import Foundation

extension Date {
    
    
    
    func startOfMonth() -> Date {
        
        let calendarType = LocalizationService.shared.calendarType
        
        let calendar = Calendar(identifier: calendarType == .jalali ? .persian : .gregorian)
        
        return calendar.date(from: calendar.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self.adding(.day, value: 1))))!
    }
        
    func endOfMonth() -> Date {
        
        let calendarType = LocalizationService.shared.calendarType
        
        let calendar = Calendar(identifier: calendarType == .jalali ? .persian : .gregorian)
        
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    
    
    
}
