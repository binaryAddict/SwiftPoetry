//
//  FailingPoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

extension PoetryService where Self == FailingPoetryService {
    static var failing: some PoetryService {
        FailingPoetryService.shared
    }
}

struct FailingPoetryService: PoetryService {
    static let shared  = FailingPoetryService()

    func authors() async throws -> [String] {
        throw ServiceError.unclassified
    }
    
    func poems(author: String) async throws -> [Poem] {
        throw ServiceError.unclassified
    }
}
