//
//  PoetryStore.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

protocol PoetryStore: PoetryService {
    func authors() async throws -> [String]
    func poems(author: String) async throws -> [Poem]
    func append(author: String, poems: [Poem]) async throws
}
