//
//  Launch.swift
//  SpaceX
//
//  Created by Arman Zohourian on 7/4/23.
//

import Foundation
struct Launch: Codable, Identifiable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Launch, rhs: Launch) -> Bool {
        return lhs.id == rhs.id && rhs.id == lhs.id
    }
    
    let id: String
    let fairings: Fairings?
    let links: Links?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let ships, capsules: [String]
    let crew: [CriewDataList] = []
    let payloads: [String]
    let launchpad: String
    let flightNumber: Int
    let name: String
    let dateUTC: String?
    let dateLocal: String
    let upcoming: Bool
    let cores: [Core]
    let autoUpdate: Bool?
    let tbd: Bool

    enum CodingKeys: String, CodingKey {
        case fairings, links, net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad, flightNumber, name, dateUTC, dateLocal, upcoming, cores, autoUpdate, tbd, id
    }
}
