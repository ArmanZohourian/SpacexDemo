//
//  BusinessInfoResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/21/22.
//

import Foundation
struct BusinessInfoResponse : Codable {
    
    var data: [BusinessInfo]
    var status: Bool

}

struct BusinessInfo: Codable {
    
    
    var branchId: Int
    var contactType: String
    var typeName: String
    var cityName: String
    var logo: String
    var location: String
    var updatedAt: String
    var address: String
    var businessLogo: String?
    var businessName: String
    var businessIdentityNumber: Double
    var businessCreatedAt: String
    var contactId: Int
    var phoneNumber: String
    var businessId: Int
    
}
