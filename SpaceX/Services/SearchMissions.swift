//
//  SearchMissions.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/2/23.
//

import Foundation
enum SearchMissions: RequestProtocol {

    case getMissionsWith(upcoming: Bool, limit: Int, pageNumber: Int, sort: String, searchText: String)
    
    var path: String {
        return "/v5/launches/query"
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
        case let .getMissionsWith(upcoming, limit, pageNumber, sort, searchText):
            params["query"] = ["upcoming": upcoming , "$search" : [searchText]]
            params["options"] = ["limit": limit, "page": pageNumber, "sort": ["flight_number": sort]]
            
        }
        return params
    }
}

