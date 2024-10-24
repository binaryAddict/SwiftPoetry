//
//  PoemViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

@MainActor
@Observable
class PoemViewModel: Chainable {
    
    var estimatedDuration: TimeInterval {
        (TimeInterval(wordsCount) * 60)  / TimeInterval(settings.wordsPerMinute.value)
    }
    
    let poem: Poem
    private let wordsCount: Int
    private let poetryServiceProvider: PoetryServiceProvider
    private let settings: Settings
    
    init(poem: Poem, poetryServiceProvider: PoetryServiceProvider = .shared, settings: Settings = .shared) {
        self.poem = poem
        self.wordsCount = poem.lines.reduce(0) {
            $0 + $1.split(separator: " ").count
        }
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
    }
    
    func speedReederNavigation() -> some Hashable {
        SpeedReadingNavigation(poem: poem, poetryServiceProvider: poetryServiceProvider, settings: settings)
    }
}

extension PoemViewModel {
    static func makePreview(
        poem: Poem = PoetryStubs.shortPoem,
        mode: PoetryServiceProvider.TestMode = .offlineOnly) -> PoemViewModel
    {
        .init(
            poem: poem,
            poetryServiceProvider: .testPreview(mode: mode),
            settings: .makeUnbacked()
        )
    }
}
