//
//  UserDefaultsSettingsStore.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

extension SettingsStore where Self == UserDefaultsSettingsStore {
    static var userDefaults: some SettingsStore {
        UserDefaultsSettingsStore.shared
    }
}

class UserDefaultsSettingsStore: SettingsStore {
    
    static let shared = UserDefaultsSettingsStore()
    
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var wordsPerMinute: WordsPerMinute? {
        get {
            return (userDefaults.value(forKey: "sp_wordsPerMinute") as? Int).flatMap {
                WordsPerMinute(value: $0)
            }
        }
        set {
            userDefaults.setValue(newValue?.value, forKey: "sp_wordsPerMinute")
        }
    }
    
    var offlineOnly: Bool? {
        get {
            return userDefaults.value(forKey: "sp_offlineOnly") as? Bool
        }
        set {
            userDefaults.setValue(newValue, forKey: "sp_offlineOnly")
        }
    }
}
