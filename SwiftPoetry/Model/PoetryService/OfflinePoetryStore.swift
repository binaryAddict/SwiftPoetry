//
//  PoetryOfflineStore.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

extension PoetryService where Self == OfflinePoetryStore {
    static var offline: some PoetryService {
        OfflinePoetryStore.shared
    }
}

extension PoetryStore where Self == OfflinePoetryStore {
    static var shared: some PoetryService {
        OfflinePoetryStore.shared
    }
}

actor OfflinePoetryStore: PoetryStore {
    
    static let shared = OfflinePoetryStore()

    private let baseURL: URL
    private let offlineURL: URL
    private let authorsURL: URL
    private let bundle: Bundle
    private var authors = [String]()
    private var poems = [String: [Poem]]()
    
    init(baseURL: URL = .applicationSupportDirectory, bundle: Bundle = .main) {
        let offlineURL = baseURL.appending(path: "Offline")
        self.baseURL = baseURL
        self.offlineURL = offlineURL
        self.authorsURL = offlineURL.appending(path: "Authors.json")
        self.bundle = bundle
    }
    
    private func poemsURL(author: String) -> URL {
        offlineURL.appending(path: "Poems").appending(path: author + ".json")
    }
    
    // only load during an async tasks
    private func perform<T>(_ action: () throws -> T ) throws -> T {
        if authors.isEmpty {
            try? FileManager.default.createDirectoryIfRequired(baseURL)
            if FileManager.default.fileExists(atPath: offlineURL.path) == false {
                try? FileManager.default.copyItem(
                    at: bundle.url(forResource: "Offline", withExtension: nil)!,
                    to: offlineURL
                )
            }
            self.authors = try .readJSONFile(authorsURL)
        }
        return try action()
    }
    
    func authors() async throws -> [String] {
        try perform {
            authors
        }
    }
    
    func poems(author: String) async throws -> [Poem] {
        try perform {
            if let result = poems[author] {
                return result
            }
            let result = try [Poem].readJSONFile(poemsURL(author: author))
            poems[author] = result
            return result
        }
    }
    
    func append(author: String, poems: [Poem]) async throws {
        try perform {
            authors.append(author)
            authors.sort()
            self.poems[author] = poems
            let data = try poems.jsonData()
            // This may take a second to parse on some devices when later loaded
            assert(data.count < 20_000_000, "Maybe consider splitting poems into individual files. Data size: \(data.count)")
            try data.write(to: poemsURL(author: author))
            try authors.writeJSONFile(authorsURL)
        }
    }
}
