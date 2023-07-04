//
//  Failure.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
struct Failure: Codable {
    let time, altitude: Int?
    let reason: String?
}
