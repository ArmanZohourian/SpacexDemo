//
//  NewShift.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import Foundation
struct NewShift : Identifiable, Codable {
    
    var id = UUID()
    var serverId : Int = -1
    var title: String
    var startHour : String
    var endHour: String
    var duration: String
    var days: [String]
    
}
