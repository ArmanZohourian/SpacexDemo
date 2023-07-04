//
//  GetObjects.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import Foundation


enum GetMissions: RequestProtocol {

    case getMissionsWith(upcoming: Bool, limit: Int, pageNumber: Int, sort: String)
    
    var path: String {
        "/v5/launches/query"
    }
    
    var reuqestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        return false
    }
    
    var params: [String : Any] {
        
        var params : [String: Any] = [:]
        
        switch self {
        case let .getMissionsWith(upcoming, limit, pageNumber, sort):
            params["query"] = ["upcoming": upcoming]
            params["options"] = ["limit": limit, "page": pageNumber, "sort": ["flight_number": sort]]
            
        }
        return params
    }
}

