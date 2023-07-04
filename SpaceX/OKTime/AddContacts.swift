//
//  AddContacts.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/28/22.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum AddContacts: RequestProtocol {
    
    
    
    var reuqestType: RequestType {
        .POST
    }
    
    case addContacts(contacts: String, token: String)

    var path: String {
        
        return "/api/v1/business/import-business-user"
        
    }
    
    var params: [String : Any] {
        switch self {
        case let .addContacts(contacts, _):
            return ["users" : contacts]
        }
    }
    
    
    var addAuthorizationToken: Bool {
        return false
    }
    
    var urlParams: [String : String?] {
        switch self {
        case let .addContacts(_, token):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    
}
