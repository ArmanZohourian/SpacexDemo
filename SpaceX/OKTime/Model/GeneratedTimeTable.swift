//
//  GeneratedTimeTable.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/18/22.
//

import Foundation


struct GeneratedTimeTable : Identifiable, Codable {
    
    
    static var staticId : Int = 0
    
    init(title: String, time: String, day: String, id: Int?, parentId: Int, isReserved: Bool?) {
        
        self.title = title
        self.time = time
        self.day = day
        if let recievedId = id {
            self.id = recievedId
        } else {
            self.id = GeneratedTimeTable.staticId
            GeneratedTimeTable.staticId = GeneratedTimeTable.staticId + 1

        }
        self.parentId = parentId

    }
    
    

    
    
    var localId: UUID = UUID()
    var parentId : Int
    var id: Int
    var title: String
    var time: String
    var day: String
    var isReserved: Bool?
    
    private func generateUinqueId() -> Int {
        let uniqueId = GeneratedTimeTable.staticId + 1
        print("Unique id is: \(uniqueId)")
        return uniqueId
        
        
    }
    
    
    
    
    
}

