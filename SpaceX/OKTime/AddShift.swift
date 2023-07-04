//
//  AddShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/15/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum AddShift : RequestProtocol {
    
case addShift(startDate: String ,endDate : String, activeDays: String, isHolidaysOn: String)
    
    var path: String {
        return "/api/v1/business/shift-config"
    }
    
    var params: [String : Any] {
        switch self {
        case let .addShift(startDate, endDate, activeDays, isHolidaysOn):
            return ["start" : startDate,
                    "end": endDate,
                    "auto_active_days": activeDays
                        ,"active_holidays" : isHolidaysOn ]
        }
    }
    
    var addAuthorizationToken: Bool {
        return true
    }

    
    
    
    var reuqestType: RequestType {
        .POST
    }
    
    
    
    
    
    
    
    
}
