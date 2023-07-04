//
//  ResetPassword.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//


///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
import Foundation
enum ResetPassword: RequestProtocol {
    
    case resetPassword(oldPassword: String, newPassword: String)
    
    
    var path: String {
        return "/api/v1/users/password/reset"
    }
    
    
    var reuqestType: RequestType {
        .PUT
    }
    
    
    var params: [String : Any] {
        
        switch self {
        case let .resetPassword( oldPassword, newPassword):
            return ["old_password" : oldPassword,
                    "new_password" : newPassword]
        }
        
    }
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    
}
