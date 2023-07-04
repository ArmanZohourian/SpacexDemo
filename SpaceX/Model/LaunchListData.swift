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
