//
//  ListData.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import Foundation
struct Category : Identifiable, Codable {
    private static var nextId = 0
    
    var id = UUID()
    
    var title : String
    var image: String?
    var subCategory: [SubCategory]?
    var isActive: Bool = true
    var serverId: Int = -1 
    //Sub category var should be assigned
    
}

