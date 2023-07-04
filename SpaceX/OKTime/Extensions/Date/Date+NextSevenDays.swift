//
//  Date+NextSevenDays.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/27/22.
//

import Foundation

extension Date {
    
    
    
    static func getNextSevenDaysDate(forLastNDays nDays: Int) -> [String] {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [String]()

        for _ in 1 ... nDays {
            // move back in time by one day:
           

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "En")
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
            
            date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
        }
        print(arrDates)
        return arrDates
    }
    
    static func getNextSevenWeekDays(forLastNDays nDays: Int) -> [String] {
        
        
        let cal = Calendar.persianCalendar
        
        var date = cal.startOfDay(for: Date())
        
        var weekDays = [String]()
        
        for _ in 1 ... nDays {
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dateString = dateFormatter.string(from: date)
            weekDays.append(dateString)
            
            date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
            
            
        }
        print(weekDays)
        return weekDays
        
    }
    
    static func getNextSevenDaysExplicitDate(forLastNDays nDays: Int) -> [Date] {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var dates = [Date]()

        for _ in 1 ... nDays {
            // move back in time by one day:
            dates.append(date)
            date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!
        }
        
        return dates
    }
    
    
    
}
