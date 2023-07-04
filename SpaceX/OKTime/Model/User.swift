//
//  User.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/23/22.
//

import Foundation

struct User: Codable {
    
    var phoneNumber :String
    
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }

}
