//
//  Task.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import Foundation


struct TaskServer : Codable {
    
    var data: [Tasks]
    var status: Bool
    
}


struct Tasks: Identifiable, Codable {
    
    var id: Int
    var createdAt: String
    var businessNameUser: String
    var actualEnd: String
    var paymentMethod: String
    var businessUserPicture: String
    var userPic: String
    var end: String
    var actualStart: String
    var start: String
    var date: String
    var cost: String
    var serviceName: String
    var status: String
    var userPhone: String
    
    
}
