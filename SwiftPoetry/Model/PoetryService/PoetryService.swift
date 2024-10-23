//
//  PoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

enum ServiceError: Error {
    case missingData
    case unclassified
}

protocol PoetryService {
    func authors() async throws -> [String]
    func poems(author: String) async throws -> [Poem]
}

extension PoetryService {
    func randomPoem() async throws -> Poem {
        let authors = try await authors()
        guard let author = authors.randomElement() else {
            throw ServiceError.missingData
        }
        let poems = try await poems(author: author)
        guard let poem = poems.randomElement() else {
            throw ServiceError.missingData
        }
        return poem
    }
}
