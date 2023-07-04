//
//  Fairings.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation

struct Fairings: Codable {
    let reused, recoveryAttempt, recovered: Bool?
    let ships: [String]
}
