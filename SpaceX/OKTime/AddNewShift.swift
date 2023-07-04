//
//  AddNewShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum AddNewShift : RequestProtocol {
    
    case addNewShift(startDate: String,endDate : String, shiftDuration: String, days: String, title: String)
    
    var path: String {
        return "/api/v1/business/shift"
    }
    
    var params: [String : Any] {
        switch self {
        case let .addNewShift(startDate, endDate, shiftDuration, days ,title):
            return ["start" : startDate,
                    "end": endDate,
                    "name": title,
                    "days" : days,
                    "book_duration": shiftDuration]
        }
    }
    
    
    var reuqestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        return true
    }
    
}
