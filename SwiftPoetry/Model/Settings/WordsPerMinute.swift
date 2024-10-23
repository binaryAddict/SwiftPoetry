//
//  WordsPerMinute.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

struct WordsPerMinute: Codable {
    static let min = 10
    static let max = 60 * 15
    private var _value: Int
    init(value: Int = 240) {
        self._value = value
        
    }
    var value: Int {
        get {
            _value
        }
        set {
            _value = Swift.max(Self.min, Swift.min(Self.max, newValue))
        }
    }
}
