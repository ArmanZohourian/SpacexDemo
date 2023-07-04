//
//  DeleteCategory.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import Foundation
///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum DeleteCategory: RequestProtocol {
    
    
    case deleteCategory(id: String)
    
    var path: String {
        return "/api/v1/business/available-service"
    }
    
    var addAuthorizationToken: Bool {
        return true
    }
    
    var urlParams: [String : String?] {
        switch self {
        case let .deleteCategory(id):
            return ["id" : id]
        }
    }
    
    var reuqestType: RequestType {
        .DELETE
    }
    
    
    
}
