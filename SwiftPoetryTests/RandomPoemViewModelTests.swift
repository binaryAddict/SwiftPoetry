//
//  RandomPoemViewModelTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 25/10/2024.
//

import XCTest
@testable import SwiftPoetry

final class RandomPoemViewModelTests: XCTestCase {

    @MainActor
    func testFetchRandomPoem_Success() throws {
        let sut = RandomPoemViewModel(
            poetryServiceProvider: .offlineOnly,
            settings: .makeUnbacked()
        )
        XCTAssertNil(sut.poem)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchRandomPoem()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.poem,
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
        XCTAssertNotNil(sut.poem)
    }
    
    @MainActor
    func testFetchRandomPoem_NetworkedFailure() throws {
        let sut = RandomPoemViewModel(
            poetryServiceProvider: .failingNetwork,
            settings: .makeUnbacked().with {
                $0.offlineOnly = false
            }
        )
        XCTAssertNil(sut.poem)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchRandomPoem()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.poem,
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
    func testFetchRandomPoem_OfflineFailure() throws {
        let sut = RandomPoemViewModel(
            poetryServiceProvider: .failingOffline,
            settings: .makeUnbacked().with {
                $0.offlineOnly = true
            }
        )
        XCTAssertNil(sut.poem)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchRandomPoem()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.poem,
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
