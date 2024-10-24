//
//  SpeedReadingViewModel.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct RunInfo {
    var started = false
    var wordIndex = 0
    var totalDuration = TimeInterval(0)
    var duration = TimeInterval(0)
}

@MainActor
@Observable
class SpeedReadingViewModel: ObjectInstanceHashable, Chainable {
    
    var targetWordDuration: TimeInterval {
        60 / TimeInterval(settings.wordsPerMinute.value)
    }
    var currentWord: Substring {
        words[runInfo.wordIndex]
    }
    var complete: Float {
        let lastWord: Float = runInfo.duration >= targetWordDuration ? 1 : 0
        return (lastWord + Float(runInfo.wordIndex)) / Float(words.count)
    }
    var averageWordPerMinute: Float {
        let words = complete == 1 ? words.count : runInfo.wordIndex
        return Float(words) * 60 / Float(runInfo.totalDuration)
    }
    var estimatedDuration: TimeInterval {
        (TimeInterval(words.count) * 60)  / TimeInterval(settings.wordsPerMinute.value)
    }
    
    let poem: Poem
    let words: [Substring]
    var isPaused = true {
        didSet {
            displayLink.paused = isPaused
        }
    }
    var runInfo = RunInfo()
    private let displayLink = DisplayLinkController(paused: true)
    private var token: Any?
    private let poetryServiceProvider: PoetryServiceProvider
    var settings: Settings
    
    init(poem: Poem, poetryServiceProvider: PoetryServiceProvider = .shared, settings: Settings = .shared) {
        self.poem = poem
        self.poetryServiceProvider = poetryServiceProvider
        self.settings = settings
        self.words = poem.lines.flatMap {
            $0.split(separator: " ")
        }
        token = displayLink.update.sink { [weak self] change in
            guard let self else { return }
            guard complete != 1 else { return }
            runInfo.duration += change.duration
            runInfo.totalDuration += change.duration
            guard runInfo.duration > targetWordDuration, complete != 1 else { return }
            runInfo.duration -= targetWordDuration
            runInfo.wordIndex += 1
        }
    }
    
    func onAppear() {
//        start()
    }
    
    func reset() {
        runInfo = .init()
    }
    
    func start() {
        reset()
        runInfo.started = true
        isPaused = false
    }
    
    func selectionRootNavigation() -> some Hashable {
        SelectionRootViewModel(poetryServiceProvider: poetryServiceProvider, settings: settings)
    }
}

extension SpeedReadingViewModel {
    static func makePreview(
        poem: Poem = PoetryStubs.shortPoem,
        mode: PoetryServiceProvider.TestMode = .offlineOnly) -> SpeedReadingViewModel
    {
        .init(
            poem: poem,
            poetryServiceProvider: .testPreview(mode: mode),
            settings: .makeUnbacked()
        )
    }
}
