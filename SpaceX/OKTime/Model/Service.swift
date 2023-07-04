//
//  Service.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import Foundation

struct Service: Identifiable, Codable {
    
    var parentId: Int?
    var id: Int
    var estimatedTime: String?
    var activate: Bool
    var imageName: String?
    var name: String
    var cost: Int?
    var childs : [Service]?
}


struct SubService: Identifiable, Codable {
    
    
    var parentId: Int?
    var id: Int
    var estimatedTime: String?
    var activate: Bool
    var imageName: String?
    var cost: String?
    var name: String
    
}
