//
//  SubmitCategory.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/30/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum SubmitCategory: RequestProtocol {
    
    case submitWith(name: String, price: Double, token: String)
    
    var path: String {
        return "/api/v1/business/available-service"
    }
    
    var reuqestType: RequestType {
        return .POST
    }
    
    var params: [String : Any] {
        switch self {
        case let .submitWith(name, price, token):
            return ["name" : name ,
                    "cost" : price]
        }
    }
    
    var addAuthorizationToken: Bool {
        return false
    }
    
    var headers: [String : String] {
        switch self {
        case let .submitWith(_ , _ , token):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    
    
    
    
    
    
    
}
