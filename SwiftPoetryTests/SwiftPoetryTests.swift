//
//  SwiftPoetryTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 20/10/2024.
//

import XCTest
@testable import SwiftPoetry

final class SwiftPoetryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testExample() throws {
        AppStorageKey.removeAllValues()
        var model = HomeViewModel()
        XCTAssert(model.offlineOnly == false)
        model.offlineOnly = true
        XCTAssert(model.offlineOnly)
        model = HomeViewModel()
        XCTAssert(model.offlineOnly)
        AppStorageKey.removeAllValues()
        model = HomeViewModel()
        XCTAssert(model.offlineOnly == false)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
