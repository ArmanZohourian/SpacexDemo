//
//  Shift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import Foundation
struct Shift: Identifiable, Codable {
    
    var serverId : Int = -1
    var id = UUID()
    var startDate: String
    var endDate: String
    var activeDays: String
    var isHolidaysOn: Bool
    
}
