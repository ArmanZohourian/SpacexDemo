//
//  ServicesResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation

struct ServicesResponse: Codable {

    var data: [Service]
    var status: Bool
    var msg: String?
    
}
