//
//  NetworkPoetryService.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

struct AuthorsResponse: Codable {
    let authors: [String]
}

extension PoetryService where Self == NetworkPoetryService {
    static var network: some PoetryService {
        NetworkPoetryService.shared
    }
}

struct NetworkPoetryService: PoetryService {
    static let shared  = NetworkPoetryService()
    
    private let baseURL = URL(string: "https://poetrydb.org")!
    
    func authors() async throws -> [String] {
        let url = baseURL.appending(path: "author")
        let urlResponse = try await URLSession.shared.data(for: .init(url: url))
        return try AuthorsResponse.readJSONData(urlResponse.0).authors
    }
    
    func poems(author: String) async throws -> [Poem] {
        let url = baseURL.appending(path: "author/\(author)")
        let urlResponse = try await URLSession.shared.data(for: .init(url: url))
        return try .readJSONData(urlResponse.0)
    }
}
