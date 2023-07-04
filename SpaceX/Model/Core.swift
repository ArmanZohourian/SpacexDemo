//
//  Core.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation

struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused: Bool?
    let landingAttempt, landingSuccess: Bool?
    let landingType, landpad: String?
}
