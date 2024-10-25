//
//  AuthorsViewModelTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 25/10/2024.
//

import XCTest
@testable import SwiftPoetry

final class AuthorsViewModelTests: XCTestCase {

    @MainActor
    func testFetchAuthors_Success() throws {
        let sut = AuthorsViewModel(
            poetryServiceProvider: .offlineOnly,
            settings: .makeUnbacked()
        )
        XCTAssert(sut.authors.isEmpty)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchAuthors()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.authors,
                sut.presentNetworkedError,
                sut.presentOfflineError
            )
        } onChange: {
            completion.fulfill()
        }
        wait(for: [completion])
        
        XCTAssertFalse(sut.fetching)
        XCTAssertFalse(sut.presentNetworkedError)
        XCTAssertFalse(sut.presentOfflineError)
        XCTAssertFalse(sut.authors.isEmpty)
    }
    
    @MainActor
    func testFetchAuthors_NetworkedFailure() throws {
        let settings = Settings.makeUnbacked()
        settings.offlineOnly = false
        let sut = AuthorsViewModel(
            poetryServiceProvider: .failingNetwork,
            settings: settings
        )
        XCTAssert(sut.authors.isEmpty)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchAuthors()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.authors,
                sut.presentNetworkedError,
                sut.presentOfflineError
            )
        } onChange: {
            completion.fulfill()
        }
        wait(for: [completion])
        
        XCTAssertFalse(sut.fetching)
        XCTAssert(sut.presentNetworkedError)
        XCTAssertFalse(sut.presentOfflineError)
    }
    
    @MainActor
    func testFetchAuthors_OfflineFailure() throws {
        let settings = Settings.makeUnbacked()
        settings.offlineOnly = true
        let sut = AuthorsViewModel(
            poetryServiceProvider: .failingOffline,
            settings: settings
        )
        XCTAssert(sut.authors.isEmpty)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchAuthors()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.authors,
                sut.presentNetworkedError,
                sut.presentOfflineError
            )
        } onChange: {
            completion.fulfill()
        }
        wait(for: [completion])
        
        XCTAssertFalse(sut.fetching)
        XCTAssertFalse(sut.presentNetworkedError)
        XCTAssert(sut.presentOfflineError)
    }
}
