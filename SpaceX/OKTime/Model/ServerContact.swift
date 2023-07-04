//
//  ServerContact.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import Foundation

struct ServerContactContainer : Codable {
    
    var data: ServerData
    var status: Bool
}

struct ServerData: Codable {
    
    var total: Int
    var businessUsers: [ContactData]
    
}

struct ContactData: Codable, Identifiable {
    
    var id: Int
    var name: String
    var phone: String
    var image: String?
    
}
