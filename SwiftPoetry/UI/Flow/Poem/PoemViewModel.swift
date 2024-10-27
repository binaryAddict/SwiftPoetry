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
    var estimatedReady: Bool {
        wordsCount > 0
    }
    
    let poem: Poem
    private(set) var wordsCount: Int = 0
    
    private let settings: Settings
    
    init(poem: Poem, settings: Settings) {
        self.settings = settings
        self.poem = poem
    }
    
    func onAppear() {
        guard wordsCount == 0 else { return }
        let poem = self.poem
        DispatchQueue.main.asyncAwait {
            /*
             Async is maybe over kill.
             Even with Lord Byron: Don Jaun (18K+ lines, 120K words) it is <0.1 sec and not noticable.
             
             Given
             */
            poem.lines.reduce(0) {
                $0 + $1.split(separator: " ").count
            }
        } completion: { [weak self] in
            guard let self else { return }
            self.wordsCount = $0
        }
    }
    
    func speedReederNavigation() -> some Hashable {
        SpeedReadingNavigation(poem: poem)
    }
}

extension PoemViewModel {
    static func make(poem: Poem, dependacySource: DependacySource) -> PoemViewModel {
        .init(poem: poem, settings: dependacySource.settings)
    }
}
