//
//  AppStorageKey.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

enum AppStorageKey: String, CaseIterable {
    case offlineOnly
    case wordsPerMinute
    static func removeAllValues(userDefaults: UserDefaults = .standard) {
        allCases.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }
    }
}

struct WordsPerMinute: Codable {
    static let min = 15
    static let max = 60 * 15
    var value = 240
}

extension WordsPerMinute: RawRepresentable {
    var rawValue: Int {
        value
    }
    init?(rawValue: Int) {
        self.value = rawValue
    }
}


enum AppStorageDefaultValue {
    static let offlineOnly = false
    static let wordsPerMinute = WordsPerMinute()
}

