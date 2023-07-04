//
//  ShiftResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation

struct ShiftResponse: Codable {
    
    var data: ShiftData?
    var status: Bool
    
}


struct ShiftData: Codable {
    
    var activeDays: [ActiveDayData]
    var configs : [ConfigsData]
    
}

struct ActiveDayData : Codable {
    var date: String
}

struct ConfigsData: Codable {
    
    var key: String
    var value: String
    
}
