//
//  UnbackedSettingsStore.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

extension SettingsStore where Self == UnbackedSettingsStore {
    static func makeUnstored() -> some SettingsStore {
        UnbackedSettingsStore()
    }
}

class UnbackedSettingsStore: SettingsStore {
    var wordsPerMinute: WordsPerMinute?
    var offlineOnly: Bool?
    init(wordsPerMinute: WordsPerMinute? = nil, offlineOnly: Bool? = nil) {
        self.wordsPerMinute = wordsPerMinute
        self.offlineOnly = offlineOnly
    }
}
