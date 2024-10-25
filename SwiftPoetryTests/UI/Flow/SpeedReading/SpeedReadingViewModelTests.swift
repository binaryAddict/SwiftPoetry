//
//  SpeedReadingViewModelTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 25/10/2024.
//

import XCTest
@testable import SwiftPoetry
import Combine

private class DisplayLinkControllerMock: DisplayLinkControllerProtocol {
    var update: PassthroughSubject<SwiftPoetry.DisplayLinkUpdate, Never> = .init()
    var paused: Bool = true
}

final class SpeedReadingViewModelTests: XCTestCase {
    
    @MainActor func testStart() throws {
        let displayLink = DisplayLinkControllerMock()
        let sut = SpeedReadingViewModel(
            poem: PoetryStubs.veryShortPoem,
            settings: .makeUnbacked(),
            displayLink: displayLink
        )
        XCTAssert(sut.isPaused)
        XCTAssert(displayLink.paused)
        XCTAssertEqual(sut.words.count, 2)
        sut.start()
        XCTAssertFalse(sut.isPaused)
        XCTAssertFalse(displayLink.paused)
    }
    
    @MainActor func testDisplayLink_Update() throws {
        let displayLink = DisplayLinkControllerMock()
        let sut = SpeedReadingViewModel(
            poem: PoetryStubs.veryShortPoem,
            settings: .makeUnbacked().with {
                $0.wordsPerMinute.value = 60
            },
            displayLink: displayLink
        )
        sut.start()
        XCTAssertEqual(sut.words.count, 2)
        XCTAssertEqual(sut.targetWordDuration, 1)
        XCTAssertEqual(sut.runInfo.wordIndex, 0)
        XCTAssertEqual(sut.complete, 0)
        
        // Not enough to update
        displayLink.update.send(.init(duration: 0.5))
        XCTAssertEqual(sut.runInfo.wordIndex, 0)
        XCTAssertEqual(sut.complete, 0.25)
        
        // Enough to update
        displayLink.update.send(.init(duration: 0.5))
        XCTAssertEqual(sut.runInfo.wordIndex, 1)
        XCTAssertEqual(sut.complete, 0.5)
        
        // LARGER DURATION CHANGE: Enough to update
        displayLink.update.send(.init(duration: 1))
        XCTAssertEqual(sut.runInfo.wordIndex, 1)
        XCTAssertEqual(sut.complete, 1)
    }
    
}
