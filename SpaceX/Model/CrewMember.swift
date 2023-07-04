//
//  Crew.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation

struct CrewMember: Identifiable, Codable {
    let id: String
    let name: String
    var role: String?
}
