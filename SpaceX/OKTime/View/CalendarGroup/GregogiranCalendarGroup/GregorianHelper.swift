//
//  GregorianHelper.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/15/22.
//

import Foundation

class GregorianHelper {
    
    
    static let DayEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        
        return formatter
    }()
    
    
    static let MonthEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en")
        
        return formatter
    }()
    
    static let YearEn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en")
        
        return formatter
    }()
    
    
    
    
    
}
