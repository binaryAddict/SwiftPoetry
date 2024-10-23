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
class SpeedReadingViewModel {
    
    var dismiss = {}
    var targetWordDuration: TimeInterval {
        60 / TimeInterval(wordPerMinute.value)
    }
    var currentWord: Substring {
        words[runInfo.wordIndex]
    }
    var complete: Float {
        let lastWord: Float = runInfo.duration >= targetWordDuration ? 1 : 0
        return (lastWord + Float(runInfo.wordIndex)) / Float(words.count)
    }
    
    @ObservationIgnored @AppStorage(AppStorageKey.wordsPerMinute.rawValue) var wordPerMinute = AppStorageDefaultValue.wordsPerMinute
    
    let poem: Poem
    let words: [Substring]
    var isPaused = true {
        didSet {
            displayLink.paused = isPaused
        }
    }
    private(set) var runInfo = RunInfo()
    private let displayLink = DisplayLinkController(paused: true)
    private var token: Any?
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(poem: Poem, poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.poem = poem
        self.poetryServiceProvider = poetryServiceProvider
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
        start()
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
        SelectionRootNavigation(poetryServiceProvider: poetryServiceProvider)
    }
}
