//
//  Date+AllMonthsOfYear.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import Foundation


extension Date {
    
    

    var startOfYear: Date {
        
        let calendarType = LocalizationService.shared.calendarType

        let calendar = Calendar(identifier: calendarType == .jalali ? .persian : .gregorian)
        let components = calendar.dateComponents([.year], from: Date())

        
        return  calendar.date(from: components)!
    }
    
    
    
    var endOfYear: Date {
        
        let calendarType = LocalizationService.shared.calendarType
        
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: calendarType == .jalali ? .persian : .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    func allMonthsOfYear() -> [Date] {
        
        var startOfYear = Date().startOfYear
        let endOfYear = Date().endOfYear
        var generatedDates = [Date]()

        while startOfYear <= endOfYear {
            
           let newDate =  startOfYear
            generatedDates.append(newDate)
            startOfYear = startOfYear.adding(.day, value: 1)
            startOfYear = startOfYear.adding(.month, value: 1)
            
        }
        return generatedDates
    }
    

    
}
