//
//  GeneralModel.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import Foundation

//MARK: Main struct
struct LaunchListData: Codable {
    
    let docs: [Launch]?
    let offset: Int?
    let totalDocs, limit, totalPages: Int
    let page, pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}



//MARK: Flickr
struct Flickr: Codable {
    let small, original: [String]
}
//MARK: Patch
struct Patch: Codable {
    let small, large: String?
}
//MARK: Reddit
struct Reddit: Codable {
    let campaign: String?
    let launch, media, recovery: String?
}
//MARK: Failure
struct Failure: Codable {
    let time, altitude: Int?
    let reason: String?
}

struct Crew: Codable {
    let crew, role: String
}

