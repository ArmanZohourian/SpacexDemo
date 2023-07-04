//
//  ContactResponseModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/28/22.
//

import Foundation


struct ContactResponseModel: Decodable {
    
    var status: Bool
    var result: Int
    var msg: String?
    
}
