//
//  FailingNetworkPoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

extension PoetryService where Self == FailingNetworkPoetryService {
    static var failingNetwork: some PoetryService {
        FailingNetworkPoetryService.shared
    }
}

struct FailingNetworkPoetryService: PoetryService {
    static let shared  = FailingNetworkPoetryService()
    let waitTime: TimeInterval
    init(waitTime: TimeInterval = 1) {
        self.waitTime = waitTime
    }
    
    private func wait() async throws {
        try await Task.sleep(nanoseconds: UInt64(waitTime * Double(NSEC_PER_SEC)))
    }

    func authors() async throws -> [String] {
        try await wait()
        throw ServiceError.unclassified
    }
    
    func poems(author: String) async throws -> [Poem] {
        try await wait()
        throw ServiceError.unclassified
    }
}
