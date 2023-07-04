//
//  AddMultipleContacts.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/7/23.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum AddMultipleContacts : RequestProtocol {
    
    
    case addContacts(contacts: [[String: String]])
    
    var path: String {
        return "/api/v1/business/import-business-user"
    }
    
    var reuqestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    //Parameters
    var params: [String : Any] {
        
        switch self {
        case let .addContacts(contacts):
            
            return ["users": contacts]
        }
    }
     
    
    
}
