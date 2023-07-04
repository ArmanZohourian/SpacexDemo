//
//  ShiftDetailResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import Foundation

struct ShiftDetailsResponse: Codable {
    
    
    var data: Shifts
    var status: Bool
    var msg: String?
    
    
    
    
}


struct Shifts: Codable {
    var shifts: [ShiftDetail]
}



struct ShiftDetail: Codable, Identifiable {
    
    var name: String
    var end: String
    var bookDuration: String
    var start: String
    var id: Int
    var weekDay: [String]
    
    
}
