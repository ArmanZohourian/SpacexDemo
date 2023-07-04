//
//  ReportsResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation

struct ReportsResponse: Codable {
    
    
    var status: Bool
    var msg: String?
    var data: Reports?
    
    
}


struct Reports: Codable {
    
    var totalDone: Int
    var totalCancel: Int
    var averageTime: Int
    
}
