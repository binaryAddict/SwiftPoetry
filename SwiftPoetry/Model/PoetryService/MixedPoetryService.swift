//
//  MixedPoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

extension PoetryService where Self == MixedPoetryService {
    static var main: some PoetryService {
        MixedPoetryService.shared
    }
    static var mixed: some PoetryService {
        MixedPoetryService.shared
    }
}

actor MixedPoetryService: PoetryService {
    static let shared = MixedPoetryService()
    
    private let server: any PoetryService
    private let offline: any PoetryStore
    private var authors: [String]?
    
    init(server: any PoetryService = NetworkPoetryService.shared, offline: any PoetryStore = OfflinePoetryStore()) {
        self.server = server
        self.offline = offline
    }
    
    func authors() async throws -> [String] {
        if let authors {
            return authors
        }
        let result = try await server.authors()
        authors = result
        return result
    }
    
    func poems(author: String) async throws -> [Poem] {
        if let result = try? await offline.poems(author: author) {
            return result
        }
        let result = try await server.poems(author: author)
        Task(priority: .background) {
            try? await offline.append(author: author, poems: result)
        }
        return result
    }
}
