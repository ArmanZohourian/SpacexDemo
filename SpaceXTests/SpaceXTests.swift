//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by Arman Zohourian on 6/27/23.
//

import XCTest
@testable import SpaceX
final class SpaceXTests: XCTestCase {
    
    var viewModel: ShuttleViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        viewModel = ShuttleViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        try super.tearDownWithError()
    }

    // MARK: - Test getLaunches() function

    func testGetLaunches() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch launches")

        // When
        Task {
            await viewModel.getLaunches()
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation])
        XCTAssertTrue(viewModel.alllaunches.count == 20, "Launches should be fetched")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
        XCTAssertFalse(viewModel.hasError, "hasError should be false")
    }

    // MARK: - Test getNextSetOfLaunches() function

    func testGetNextSetOfLaunches() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Fetch next set of launches")

        // When
        Task {
            await viewModel.getNextSetOfLaunches()
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation])
        XCTAssertTrue(viewModel.alllaunches.count >= 20, "Next set of launches should be fetched")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}





