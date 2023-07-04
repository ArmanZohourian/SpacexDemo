//
//  BusinessInformation.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/3/22.
//

import Foundation


struct BusinessInfoWebResponse: Codable {
    
    var data: BusinessInformation?
    var status: Bool
    var msg: String?
    
}

struct BusinessInformation: Codable {
    
    
    var updatedAt: String
    var businessName: String
    var contactId: Int
    var businessCreatedAt: String
    var contactType: String
    var cityName: String
    var businessLogo: String?
    var businessIdentityNumber: Double
    var cityNameLocal: String
    var phoneNumber: String
    var businessId: Int
    var branchId: Int
    var location: String
    var address: String
    var logo: String
    var typeName: String
    
    
    
}
