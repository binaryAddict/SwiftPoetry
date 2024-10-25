//
//  MixedPoetryServiceTests.swift
//  SwiftPoetryTests
//
//  Created by Dominic Campbell on 25/10/2024.
//

import XCTest
@testable import SwiftPoetry

private class WrappedPoetryStore<Backing: PoetryStore>: PoetryStore {
    
    var backing: Backing
    init(backing: Backing) {
        self.backing = backing
    }
    
    var authorsCalls = 0
    func authors() async throws -> [String] {
        authorsCalls += 1
        return try await backing.authors()
    }
    
    var poemsCalls = 0
    func poems(author: String) async throws -> [Poem] {
        poemsCalls += 1
        return try await backing.poems(author: author)
    }
    
    var appendCallback: () -> Void = {}
    var appendCalls = 0
    func append(author: String, poems: [Poem]) async throws {
        appendCalls += 1
        appendCallback()
        try await backing.append(author: author, poems: poems)
    }
}

private struct EmptyPoetryStore: PoetryStore {
    
    func authors() async throws -> [String] {
        []
    }
    
    func poems(author: String) async throws -> [SwiftPoetry.Poem] {
        []
    }
    
    func append(author: String, poems: [SwiftPoetry.Poem]) async throws {
        
    }
}

extension FailingPoetryService: PoetryStore {
    public func append(author: String, poems: [SwiftPoetry.Poem]) async throws {
        throw ServiceError.unclassified
    }
}

final class MixedPoetryServiceTests: XCTestCase {

    func testAuthors_onlyCalledOnce() async throws {
        let server = WrappedPoetryStore(backing: OfflinePoetryStore.shared)
        let sut = MixedPoetryService(
            server: server,
            offline: EmptyPoetryStore()
        )
        let a = try await sut.authors()
        _ = try await sut.authors()
        let b = try await sut.authors()
        XCTAssertFalse(a.isEmpty)
        XCTAssertEqual(a, b)
        XCTAssertEqual(server.authorsCalls, 1)
    }
    
    func testPoems_AvailableOffine_ServerNotCall() async throws {
        let offline = WrappedPoetryStore(backing: OfflinePoetryStore.shared)
        let server = WrappedPoetryStore(backing: OfflinePoetryStore.shared)
        let sut = MixedPoetryService(
            server: server,
            offline: offline
        )
        let poems = try await sut.poems(author: PoetryStubs.authorJonathanSwift)
        XCTAssertEqual(poems, PoetryStubs.jonathanSwiftPoems)
        XCTAssertEqual(offline.poemsCalls, 1)
        XCTAssertEqual(server.poemsCalls, 0)
    }
    
    func testPoems_NotAvailableOffine_ServerCall() async throws {
        let offline = WrappedPoetryStore(backing: FailingPoetryService())
        let server = WrappedPoetryStore(backing: OfflinePoetryStore.shared)
        let sut = MixedPoetryService(
            server: server,
            offline: offline
        )
        let poems = try await sut.poems(author: PoetryStubs.authorJonathanSwift)
        XCTAssertEqual(poems, PoetryStubs.jonathanSwiftPoems)
        XCTAssertEqual(offline.poemsCalls, 1)
        XCTAssertEqual(server.poemsCalls, 1)
    }
    
    func testPoems_NotAvailableOffine_ServerPoemsAddedToOfflineStore() async throws {
        let offline = WrappedPoetryStore(backing: FailingPoetryService())
        let server = WrappedPoetryStore(backing: OfflinePoetryStore.shared)
        let sut = MixedPoetryService(
            server: server,
            offline: offline
        )
        let completion = XCTestExpectation()
        offline.appendCallback = {
            completion.fulfill()
        }
        _ = try await sut.poems(author: PoetryStubs.authorJonathanSwift)
        await fulfillment(of: [completion], timeout: 0.2)
    }
}
