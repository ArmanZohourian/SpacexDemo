//
//  TimeTable.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/18/22.
//

import Foundation

struct TimeTableResult: Codable {
    let data: TimeTableData
    let status: Bool
}

// MARK: - DataClass
struct TimeTableData: Codable {
    let shifts: [TimeTable]
    let books: [Reserve]?
}

// MARK: - Shift
struct TimeTable: Codable {
    let name, end, start, bookDuration: String
    let id: Int
    let weekDay: [String]

}

struct Reserve: Codable {
    let start: String
    let end: String
}
