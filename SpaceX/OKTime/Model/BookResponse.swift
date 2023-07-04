//
//  BookResponse.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import Foundation
struct BookResponse: Codable {
    
    var data: BookData
    var status: Bool
    
}

struct BookData: Codable {
    
    var books: [Book]
    var total: Int
    
}

struct Book: Codable, Identifiable {
    
 
    var actualEnd: String?
    var userPic: String?
    var status: String
    var date: String
    var actualStart: String?
    var end: String
    var businessUserPicture: String?
    var paymentMethod: String?
    var serviceName: String
    var userPhone: String
    var createdAt: String
    var businessUserName: String
    var id: Int
    var cost: Double
    var start: String
    var businessUserId: Int
    var serviceId: Int
    
}
