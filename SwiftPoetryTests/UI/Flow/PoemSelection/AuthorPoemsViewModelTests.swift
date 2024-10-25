//
//  AuthorPoemsViewModelTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 25/10/2024.
//

import XCTest
@testable import SwiftPoetry

final class AuthorPoemsViewModelTests: XCTestCase {

    @MainActor
    func testFetchPoems_Success() throws {
        let sut = AuthorPoemsViewModel(
            author: PoetryStubs.authorJonathanSwift,
            poetryServiceProvider: .offlineOnly,
            settings: .makeUnbacked()
        )
        XCTAssert(sut.peoms.isEmpty)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchPoems()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.peoms,
                sut.presentError
            )
        } onChange: {
            completion.fulfill()
        }
        wait(for: [completion])
        
        XCTAssertFalse(sut.fetching)
        XCTAssertFalse(sut.presentError)
        XCTAssertFalse(sut.peoms.isEmpty)
    }
    
    @MainActor
    func testFetchAuthors_Failure() throws {
        let sut = AuthorPoemsViewModel(
            author: PoetryStubs.authorJonathanSwift,
            poetryServiceProvider: .failingNetwork,
            settings: .makeUnbacked().with {
                $0.offlineOnly = false
            }
        )
        XCTAssert(sut.peoms.isEmpty)
        XCTAssertFalse(sut.fetching)
        
        sut.fetchPoems()
        XCTAssert(sut.fetching)
        
        let completion = XCTestExpectation()
        _ = withObservationTracking {
            (
                sut.peoms,
                sut.presentError
            )
        } onChange: {
            completion.fulfill()
        }
        wait(for: [completion])
        
        XCTAssertFalse(sut.fetching)
        XCTAssert(sut.presentError)
    }
}
