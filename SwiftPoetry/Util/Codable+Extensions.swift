//
//  Codable+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import Foundation

extension Decodable {
    static func readJSONData(_ data: Data) throws -> Self {
        try JSONDecoder().decode(self, from: data)
    }
}
