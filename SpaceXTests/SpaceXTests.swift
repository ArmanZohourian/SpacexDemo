//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by Arman Zohourian on 6/27/23.
//

import XCTest
@testable import SpaceX

@MainActor
final class SpaceXTests: XCTestCase {

    private var launchRepository: MockLaunchRepository!
    private var viewModel: ShuttleViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        launchRepository = MockLaunchRepository()
        viewModel = ShuttleViewModel(launchRepository: launchRepository)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        launchRepository = nil
        try super.tearDownWithError()
    }

    func testGetLaunchesAddsMockedLaunches() async {
        launchRepository.result = makeLaunchListData(launches: [
            makeLaunch(id: "launch-1", flightNumber: 1),
            makeLaunch(id: "launch-2", flightNumber: 2)
        ])

        await viewModel.getLaunches()

        XCTAssertEqual(viewModel.alllaunches.count, 2)
        XCTAssertEqual(viewModel.alllaunches.map(\.id), ["launch-1", "launch-2"])
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasError)
    }

    func testGetLaunchesSetsErrorWhenRequestFails() async {
        launchRepository.error = MockLaunchRepositoryError.failed

        await viewModel.getLaunches()

        XCTAssertTrue(viewModel.alllaunches.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasError)
    }

    func testGetNextSetOfLaunchesIncrementsPageAndAppendsLaunches() async {
        launchRepository.result = makeLaunchListData(launches: [
            makeLaunch(id: "next-launch", flightNumber: 21)
        ])

        await viewModel.getNextSetOfLaunches()

        XCTAssertEqual(viewModel.pageNumber, 2)
        XCTAssertEqual(viewModel.alllaunches.count, 1)
        XCTAssertEqual(viewModel.alllaunches.first?.id, "next-launch")
    }

    func testGetLaunchesDoesNotFetchWhenLaunchesAlreadyExist() async {
        launchRepository.result = makeLaunchListData(launches: [
            makeLaunch(id: "existing-launch", flightNumber: 1)
        ])
        await viewModel.getLaunches()

        launchRepository.result = makeLaunchListData(launches: [
            makeLaunch(id: "ignored-launch", flightNumber: 2)
        ])
        await viewModel.getLaunches()

        XCTAssertEqual(launchRepository.getLaunchesCallCount, 1)
        XCTAssertEqual(viewModel.alllaunches.map(\.id), ["existing-launch"])
    }
}

private final class MockLaunchRepository: LaunchRepositoryProtocol {
    var result: LaunchListData?
    var error: Error?
    private(set) var getLaunchesCallCount = 0
    private(set) var searchLaunchesCallCount = 0

    func getLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String) async throws -> LaunchListData {
        getLaunchesCallCount += 1

        if let error {
            throw error
        }

        guard let result else {
            throw MockLaunchRepositoryError.missingResult
        }

        return result
    }

    func searchLaunches(upcoming: Bool, limit: Int, pageNumber: Int, sort: String, searchText: String) async throws -> LaunchListData {
        searchLaunchesCallCount += 1

        if let error {
            throw error
        }

        guard let result else {
            throw MockLaunchRepositoryError.missingResult
        }

        return result
    }
}

private enum MockLaunchRepositoryError: Error {
    case failed
    case missingResult
}

private func makeLaunchListData(launches: [Launch]) -> LaunchListData {
    LaunchListData(
        docs: launches,
        offset: 0,
        totalDocs: launches.count,
        limit: launches.count,
        totalPages: 1,
        page: 1,
        pagingCounter: 1,
        hasPrevPage: false,
        hasNextPage: false,
        prevPage: nil,
        nextPage: nil
    )
}

private func makeLaunch(id: String, flightNumber: Int, name: String = "Test Launch") -> Launch {
    Launch(
        id: id,
        fairings: nil,
        links: nil,
        net: false,
        window: nil,
        rocket: "rocket",
        success: true,
        failures: [],
        details: nil,
        ships: [],
        capsules: [],
        payloads: [],
        launchpad: "launchpad",
        flightNumber: flightNumber,
        name: name,
        dateUTC: nil,
        dateLocal: "2026-06-21T00:00:00+02:00",
        upcoming: false,
        cores: [],
        autoUpdate: nil,
        tbd: false
    )
}
