//
//  Date+7Days.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import Foundation


extension Date {
    static func getNextWeekDay(forLastNDays nDays: Int) -> String {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [String]()

        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates.last!
    }
}
