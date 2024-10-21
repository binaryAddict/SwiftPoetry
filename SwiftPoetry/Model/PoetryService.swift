//
//  PoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

struct AuthorsResponse: Codable {
    let authors: [String]
}

struct Poem: Hashable, Codable {
    let title: String
    let author: String
    let lines: [String]
}

actor PoetryService: ObjectInstanceHashable {

    static let shared  = PoetryService()
    
    func authors() async throws -> [String] {
        let url = URL(string: "https://poetrydb.org/author")!
        let urlResponse = try await URLSession.shared.data(for: .init(url: url))
        return try AuthorsResponse.readJSONData(urlResponse.0).authors
    }
    
    func poems(author: String) async throws -> [Poem] {
        let url = URL(string: "https://poetrydb.org/author/\(author)")!
        let urlResponse = try await URLSession.shared.data(for: .init(url: url))
        return try .readJSONData(urlResponse.0)
    }
}
