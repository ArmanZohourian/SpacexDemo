//
//  SubCategory.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/7/22.
//

import Foundation



struct SubCategory: Identifiable, Codable {
    
    var id = UUID()
    var serverId : Int = -1
    var name: String
    var categoryName: String?
    var price: String
    var image: String?
    var isActive: Bool = true

    
}

