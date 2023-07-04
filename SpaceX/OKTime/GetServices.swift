//
//  GetServices.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum GetServices: RequestProtocol {
    
    case getServices
    
    var path: String {
        return "/api/v1/business/available-service"
    }
    

    
    var addAuthorizationToken: Bool {
        return true
    }
    
    var reuqestType: RequestType {
        .GET
    }
    
}