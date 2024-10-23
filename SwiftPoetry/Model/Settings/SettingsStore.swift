//
//  SettingsStore.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import Foundation

protocol SettingsStore: AnyObject {
    var wordsPerMinute: WordsPerMinute? { get set }
    var offlineOnly: Bool? { get set }
}
