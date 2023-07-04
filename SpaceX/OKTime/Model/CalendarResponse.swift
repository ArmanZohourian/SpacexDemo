//
//  Calendar.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import Foundation

struct CalendarResponse : Codable {
    
    var status: Bool
    var data: [CalendarData]
}

struct CalendarData: Codable {
    
    var titleLocal: String
    var cancelCount: Int
    var reserveCount: Int
    var titleEn: String?
    var doneCount: Int
    var isHoliday: Bool
    var date: String
    var isActive: Bool
    var totalCost: Int?
    
    
}


struct CalendarEvent: Identifiable {
    
    var titleLocal: String
    var date: String
    var id: UUID = UUID()
    
}


struct CalendarReport: Identifiable {
    var id: UUID = UUID()
    var date: String
    var reserveCount: Int
    var totalCost: Int
    var isHoliday: Bool
    var cancelCount: Int
    var doneCount: Int
}




