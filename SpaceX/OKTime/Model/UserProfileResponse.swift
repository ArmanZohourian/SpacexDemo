//
//  UserProfile.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/3/22.
//

import Foundation

struct UserProfileResponse: Codable {
    
    var status: Bool
    var data: UserProfileInformation?
    
    
}


struct UserProfileInformation: Codable {
    
    var firstName: String
    var lastName: String
    var gender: String
    var phoneNumber: String
    var avatar: String?
}
