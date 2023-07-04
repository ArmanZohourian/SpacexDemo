//
//  UpdateSubcategoyrStatus.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/13/23.
//

import Foundation

///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum UpdateSubcategory : RequestProtocol {
    
    
    case withStatus(id: Int, status: Bool)
    
    var path: String {
        return "/api/v1/business/available-service"
    }
    
    var reuqestType: RequestType {
        .PUT
    }
    
    var params: [String : Any] {
        switch self {
        case let .withStatus(id, status):
            return ["id" : String(id),
                    "activate": String(status)]
        }
    }
    
    var addAuthorizationToken: Bool {
        true
    }
    
}
