//
//  Date+DatesBetweenTwoDates.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/30/22.
//

import Foundation


extension Date {
    
    
    
    
    var startOfWeek : Date? {
        
        let calendarType = LocalizationService.shared.calendarType
        
        let gregorian = Calendar(identifier: calendarType == .georgian ? .gregorian : .persian)
        guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: startDay)
        
    }
    
    
    var endOfWeek: Date? {
        
        let calendarType = LocalizationService.shared.calendarType
        
        let gregorian = Calendar(identifier: calendarType == .georgian ? .gregorian : .persian)
        guard let startDay = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: startDay)
        
    }
    
    
    static func getDateInBetween(startDate: Date, endDate: Date) -> [Date] {
        
        
        
        var generatedDates = [Date]()
        var localStartDate = startDate
        
        
        while localStartDate <= endDate {
            generatedDates.append(localStartDate)
            localStartDate = Calendar.current.date(byAdding: .day, value: +1, to: localStartDate)!
        }
        
        print(generatedDates)
        return generatedDates
    }
    
    
}
