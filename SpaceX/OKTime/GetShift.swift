//
//  GetShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum GetShift: RequestProtocol {
    
    case getShifts(token: String)
    
    var reuqestType: RequestType {
        .GET
    }
    
    
    var path: String {
        return "/api/v1/business/shift-config"
    }
    var headers: [String : String] {
        switch self {
        case let .getShifts(token):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    var addAuthorizationToken: Bool {
        return false
    }
    
    
}
