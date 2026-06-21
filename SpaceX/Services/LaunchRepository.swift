//
//  LaunchRepository.swift
//  SpaceX
//
//  Created by Ary on 6/21/26.
//

import Foundation

protocol LaunchRepositoryProtocol {
    func getLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String) async throws -> LaunchListData
    func searchLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String, searchText: String) async throws -> LaunchListData
}

final class LaunchRepository: LaunchRepositoryProtocol {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol = RequestManager.shared) {
        self.requestManager = requestManager
    }

    func getLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String) async throws -> LaunchListData {
        try await requestManager.perform(
            GetMissions.getMissionsWith(
                upcoming: upcoming,
                limit: limit,
                pageNumber: pageNumber,
                sort: sort
            )
        )
    }

    func searchLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String, searchText: String) async throws -> LaunchListData {
        try await requestManager.perform(
            SearchMissions.getMissionsWith(
                upcoming: upcoming,
                limit: limit,
                pageNumber: pageNumber,
                sort: sort,
                searchText: searchText
            )
        )
    }
}
