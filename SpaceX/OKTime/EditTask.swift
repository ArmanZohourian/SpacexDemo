//
//  EditTask.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import Foundation


///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum EditTask: RequestProtocol {
    
    
    case editSelectedTask(taskId: String ,contactId: String, start: String, shiftParentId: String, serviceId: String, date: String, duration: String)
    
    
    var path: String {
        return "/api/v1/business/book"
        
    }
    
    var reuqestType: RequestType {
        .PUT
    }
    
    
    
    var params: [String : Any] {
        switch self {
        case let .editSelectedTask(taskId ,contactId, start, shiftParentId, serviceId, date, duration):
            return ["id": taskId,
                    "user_id" : contactId ,
                    "start" : start ,
                    "shift_id" : shiftParentId ,
                    "available_service_id" : serviceId,
                    "date" : date,
                    "duration": duration]
        }
    }
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
    
    
}
