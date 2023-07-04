//
//  GeneratedTimeTableCollection.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/19/22.
//

import Foundation



struct GeneratedTimeTableCollection : Identifiable, Codable {
    
    static var staticId = 0
    
    var id: UUID = UUID()
    var localId: Int
    var generateTimeTable: [GeneratedTimeTable]
    var startTime: String
    var duration: String
    var endTime: String
    var unique: Int
    var name: String
    
    init(id: Int?, generatedTimeTable : [GeneratedTimeTable], startTime: String, duration: String, endTime: String, unique: Int, name: String) {
        self.localId = GeneratedTimeTableCollection.staticId
        GeneratedTimeTableCollection.staticId = GeneratedTimeTable.staticId + 1
        self.generateTimeTable = generatedTimeTable
        self.startTime = startTime
        self.duration = duration
        self.endTime = endTime
        self.unique = unique
        self.name = name
    }
    

//    var generatedStartTime: Int = 0
//    var generatedEndTime: Int = 0
}
