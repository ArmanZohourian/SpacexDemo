//
//  DeleteDailyShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//


///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
import Foundation
enum DeleteDailyShift: RequestProtocol {
    
    
    case deleteShiftWith(id: String)
    
    var reuqestType: RequestType {
        .DELETE
    }
    
    var path: String {
        return "/api/v1/business/shift"
    }
    
    var urlParams: [String : String?] {
        switch self {
        case let .deleteShiftWith(id):
            return ["id" : id]
        }
    }


    var addAuthorizationToken: Bool {
        return true
    }
    
}
