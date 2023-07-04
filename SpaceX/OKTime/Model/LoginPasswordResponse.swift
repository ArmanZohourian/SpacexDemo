//
//  LoginPasswordResponse\.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import Foundation
struct LoginPasswordResponse: Codable {
    
    
    var data: Token?
    var status: Bool
    var msg: String?
    
    
    
}

struct Token: Codable {
    
    var token: String
    
}
