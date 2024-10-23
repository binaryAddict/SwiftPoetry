//
//  Poem.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

struct Poem: Hashable, Codable {
    let title: String
    let author: String
    let lines: [String]
}
