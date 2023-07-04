//
//  BookTime.swift
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
enum BookTime: RequestProtocol {
    
    
    case bookSelectedTime(contactId: String, start: String, shiftParentId: String, serviceId: String, cost: String, date: String, duration: String)
    
    
    var path: String {
        return "/api/v1/business/book"
        
    }
    
    var reuqestType: RequestType {
        .POST
    }
    
    
    
    var params: [String : Any] {
        switch self {
        case let .bookSelectedTime(contactId, start, shiftParentId, serviceId, cost, date, duration):
            return ["user_id" : contactId ,
                    "start" : start ,
                    "shift_id" : shiftParentId ,
                    "available_service_id" : serviceId,
                    "cost" : cost,
                    "date" : date,
                    "duration": duration]
        }
    }
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
    
    
}
