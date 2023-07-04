//
//  RegisterModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/16/22.
//

import Foundation


struct RegisterModel: Codable {
    
    var data: FetchedData?
    var status: Bool
    var msg: String?
}


struct FetchedData : Codable {
    
    
    var token: String?
    var action: String?
    var cities: [City]?
    
    
    
}
