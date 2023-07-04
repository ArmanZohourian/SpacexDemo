//
//  EditShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/17/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum EditShift: RequestProtocol {
    
    
case editCurrentShift(id: String, startDate: String, endDate: String, shiftTitle: String, dayOfWeek: String, shiftDuration: String)
    
    var path: String {
        return "/api/v1/business/shift"
    }
    
    
    var params: [String : Any] {
        switch self {
        case let .editCurrentShift(id, startDate, endDate, shiftTitle, dayOfWeek, shiftDuration):
            return ["id" : id,
                    "start": startDate,
                    "end" : endDate,
                    "name": shiftTitle,
                    "days": dayOfWeek,
                    "bookDuration": shiftDuration]
        }
    }
    
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
    
    var reuqestType: RequestType {
        .PUT
    }
    
}
