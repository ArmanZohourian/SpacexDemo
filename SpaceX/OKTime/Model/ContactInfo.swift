//
//  ContactInfo.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import Foundation
import Contacts
struct ContactInfo : Identifiable {
    
    var serverId: Int = -1
    var id : UUID = UUID()
    var firstname: String
    var lastname: String
    var phoneNumber: CNPhoneNumber?
    var image: Data?
}
