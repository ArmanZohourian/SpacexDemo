//
//  GeneralModel.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/27/23.
//

import Foundation

//MARK: Main struct
struct Welcome: Codable {
    
    let docs: [Launch]?
    let offset: Int?
    let totalDocs, limit, totalPages: Int
    let page, pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

//MARK: Doc
struct Launch: Codable, Identifiable, Hashable {

    
    

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Launch, rhs: Launch) -> Bool {
        return lhs.id == rhs.id && rhs.id == lhs.id
    }
    
    let fairings: Fairings?
    let links: Links?
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let ships, capsules: [String]
    let crew: [Crew] = []
    let payloads: [String]
    let launchpad: String
    let flightNumber: Int
    let name: String
    let dateUTC: String?
    let dateUnix: Int?
    let dateLocal: String
    let datePrecision: DatePrecision?
    let upcoming: Bool
    let cores: [Core]
    let autoUpdate: Bool?
    let tbd: Bool
    let launchLibraryID: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case fairings, links, net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad, flightNumber, name, dateUTC, dateUnix, dateLocal, datePrecision, upcoming, cores, autoUpdate, tbd, launchLibraryID, id
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
    }
}

//MARK: Core
struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused: Bool?
    let landingAttempt, landingSuccess: Bool?
    let landingType, landpad: String?
}

enum DatePrecision: String, Codable {
    case day, hour, month
}

//MARK: Fairings
struct Fairings: Codable {
    let reused, recoveryAttempt, recovered: Bool?
    let ships: [String]
}

//MARK: Links
struct Links: Codable {
    let patch: Patch?
    let reddit: Reddit?
    let flickr: Flickr?
    let presskit: String?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?
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

