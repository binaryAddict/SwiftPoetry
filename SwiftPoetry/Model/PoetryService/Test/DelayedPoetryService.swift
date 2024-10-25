//
//  DelayedPoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 25/10/2024.
//

import Foundation

extension PoetryService {
    func delayed(_ delay: TimeInterval = 2) -> some PoetryService {
        DelayedPoetryService(backing: self, delay: delay)
    }
}

struct DelayedPoetryService: PoetryService {
    
    private let delay: TimeInterval
    private let backing: PoetryService
    init(backing: PoetryService, delay: TimeInterval) {
        self.backing = backing
        self.delay = delay
    }
    
    private func wait() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * Double(NSEC_PER_SEC)))
    }

    func authors() async throws -> [String] {
        try await wait()
        return try await backing.authors()
    }
    
    func poems(author: String) async throws -> [Poem] {
        try await wait()
        return try await backing.poems(author: author)
    }
}
