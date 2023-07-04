//
//  RegisterNetwork.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/27/22.
//

import Foundation

///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum Register : RequestProtocol {
    
    
    case registerBusiness(firstName: String, lastName: String, gender: String, password: String)
    
    var path: String {
        return "/api/v1/users/register"
    }
    
    var reuqestType: RequestType {
        .POST
    }
    
    var params: [String : Any] {
        switch self {
        case let .registerBusiness(firstName,lastName, gender, password):
            return ["first_name" : firstName ,
                    "last_name" : lastName ,
                    "gender" : "Male" ,
                    "password": password]
        }
    }

    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
}
