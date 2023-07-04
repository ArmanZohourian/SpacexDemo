//
//  BusinessInformation.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/29/22.
//

import Foundation

///Creating an enum which conform to request protocol,
///all the mandatory variables should be set ( e.g : path , params , requestType)
///setting the addAuthorizationToken to true if needs authorization from the API
///given the urlParams or the body params if needs any
///creating the case :
///Cases always include the body or the url params if needed and can be used to fill each of those creating the request 
enum BusinessInformationNetwork: RequestProtocol {
    
    case submitBusinessInformation(name: String, identifierId: String, address: String, location: String, cityId: String, contactInfo: String)
    
    var path: String {
        return "/api/v1/business/business"
    }
    
    var reuqestType: RequestType {
        .POST
    }
    
    var params: [String : Any] {
    
        switch self {
        case let .submitBusinessInformation(name, identifierId, address, location, cityId, contactInfo):
            return [
                    "name" : name,
                    "identity_number" : identifierId,
                    "address" : address,
                    "location" : location,
                    "city_id" : cityId,
                    "contact_info" : contactInfo]
        }
        
    }
    
    
    var addAuthorizationToken: Bool {
        return true
    }
    

}
