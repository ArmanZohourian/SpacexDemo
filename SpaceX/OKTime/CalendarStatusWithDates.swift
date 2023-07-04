//
//  CalendarStatusWithDates.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/3/22.
//

import Foundation


///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum CalendarStatusWithDates: RequestProtocol {
    
    
case getStatusWithDates(startDate: String, endDate: String)
    
    
    var path: String {
        
        return "/api/v1/business/calendar"
        
    }
    
    var reuqestType: RequestType {
        .GET
    }
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
    

    var urlParams: [String : String?] {
        switch self {
        case let .getStatusWithDates(startDate, endDate):
            return ["from": startDate,
                    "to": endDate]
        }
    }
    
    
}
