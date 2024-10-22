//
//  Codable+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

extension Decodable {
    
    static func readJSONString(_ text: String) throws -> Self {
        let data = text.data(using: .utf8)!
        let result = try JSONDecoder().decode(self, from: data)
        return result
    }
    
    static func readJSONData(_ data: Data) throws -> Self {
        try JSONDecoder().decode(self, from: data)
    }
    
    static func readJSONFile(_ url: URL) throws -> Self {
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(self, from: data)
        return result
    }
}

extension Encodable {
    func writeJSONFile(_ url: URL, withIntermediateDirectories: Bool = false) throws {
        if withIntermediateDirectories {
            try FileManager.default.createRequiredIntermediateDirectories(url)
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        try data.write(to: url)
    }
    
    func jsonString() throws -> String  {
        String(data: try jsonData(), encoding: .utf8)!
    }
    
    func jsonData() throws -> Data  {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }
}
