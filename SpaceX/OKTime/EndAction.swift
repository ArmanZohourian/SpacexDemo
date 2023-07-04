//
//  EndAction.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum EndAction : RequestProtocol {
    
    
    case endAction(id: Int,cost: Double,startTime: String,endTime: String ,paymentMethod: String)
    
    var path: String {
        return "/api/v1/business/book/end"
    }
    
    var params: [String : Any] {
        switch self {
        case let .endAction(id, cost, startTime, endTime, paymentMethod):
            return ["id" : id,
                    "start" : startTime,
                    "end": endTime,
                    "cost": cost,
                    "payment_type" : paymentMethod]
        }
    }
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    var reuqestType: RequestType {
        .PUT
    }
}
