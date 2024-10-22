//
//  PoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

enum ServiceError: Error {
    case missingData
}

protocol PoetryService {
    func authors(offlineOnly: Bool) async throws -> [String]
    func poems(offlineOnly: Bool, author: String) async throws -> [Poem]
}

extension PoetryService {
    func randomPoem(offlineOnly: Bool = false) async throws -> Poem {
        let authors = try await authors(offlineOnly: offlineOnly)
        guard let author = authors.randomElement() else {
            throw ServiceError.missingData
        }
        let poems = try await poems(offlineOnly: offlineOnly, author: author)
        guard let poem = poems.randomElement() else {
            throw ServiceError.missingData
        }
        return poem
    }
}


extension PoetryService where Self == PoetryServiceImp {
    static var shared: some PoetryService {
        PoetryServiceImp.shared
    }
}

actor PoetryServiceImp: PoetryService {
    static let shared = PoetryServiceImp()
    
    private let server: any PoetryServer
    init(server: any PoetryServer = .shared) {
        self.server = server
    }
    
    func authors(offlineOnly: Bool) async throws -> [String] {
        try await server.authors()
    }
    
    func poems(offlineOnly: Bool, author: String) async throws -> [Poem] {
        try await server.poems(author: author)
    }
}
