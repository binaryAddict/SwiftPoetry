//
//  Settings.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

@Observable
final class Settings: Chainable {
    
    static let shared = Settings()
    static func makeUnbacked() -> Settings {
        Settings(settingsStore: .makeUnstored())
    }
    
    private let settingsStore: any SettingsStore
    init(settingsStore: any SettingsStore = .userDefaults) {
        self.settingsStore = settingsStore
        self.wordsPerMinute = settingsStore.wordsPerMinute ?? WordsPerMinute()
        self.offlineOnly = settingsStore.offlineOnly ?? false
    }
    
    var wordsPerMinute: WordsPerMinute {
        didSet {
            settingsStore.wordsPerMinute = wordsPerMinute
        }
    }
    var offlineOnly: Bool {
        didSet {
            settingsStore.offlineOnly = offlineOnly
        }
    }
}
