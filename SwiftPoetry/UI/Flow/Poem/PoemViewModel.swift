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
    private let settings: Settings
    
    init(poem: Poem, settings: Settings = .shared) {
        self.poem = poem
        self.wordsCount = poem.lines.reduce(0) {
            $0 + $1.split(separator: " ").count
        }
        self.settings = settings
    }
    
    func speedReederNavigation() -> some Hashable {
        SpeedReadingNavigation(poem: poem, settings: settings)
    }
}

extension PoemViewModel {
    static func makePreview(poem: Poem = PoetryStubs.shortPoem) -> PoemViewModel
    {
        .init(poem: poem, settings: .makeUnbacked())
    }
}
