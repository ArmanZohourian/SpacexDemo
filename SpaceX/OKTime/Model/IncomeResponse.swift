//
//  IncomeResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import Foundation


struct IncomeReportResponse: Codable {
    
    var data: IncomeReport?
    var status: Bool
    var msg: String?
    
}


struct IncomeReport: Codable {
    
    var income: Int?
    var totalIncome: Int?
    
}
