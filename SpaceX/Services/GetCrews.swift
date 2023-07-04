//
//  GetCrews.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
enum GetCrews: RequestProtocol {
    
    case byCrewId(crewId: String)
    
    var path: String {
        switch self {
        case .byCrewId(let crewId):
            return "/v4/crew/\(crewId)"
        }
    }
    
    var reuqestType: RequestType {
        .GET
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}
