//
//  SpeedReadingView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct SpeedReadingView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        if viewModel.runInfo.started == false {
            PoemView(viewModel: viewModel)
        } else {
            if viewModel.complete == 1 {
                CompletionView(viewModel: viewModel)
            } else {
                RunnerView(viewModel: viewModel)
            }
        }
    }
}

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

struct RunnerView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        ZStack {
            Text(viewModel.currentWord)
                .font(.title2)
//                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.reset()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .padding(16)
                    .opacity(viewModel.isPaused ? 1 : 0)
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    Spacer()
                    Button {
                        viewModel.isPaused.toggle()
                    } label: {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                    }
                    .padding(16)
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(viewModel.wordPerMinute.value)")
                            .opacity(viewModel.isPaused ? 1 : 0)
                        HStack(spacing: 16) {
                            Button {
                                viewModel.wordPerMinute.value -= 10
                            } label: {
                                Image(systemName: "minus")
                            }
                            .disabled(viewModel.wordPerMinute.value == WordsPerMinute.min)
                            Button {
                                viewModel.wordPerMinute.value += 10
                            } label: {
                                Image(systemName: "plus")
                            }
                            .disabled(viewModel.wordPerMinute.value == WordsPerMinute.max)
                        }
                    }
                    .disabled(viewModel.complete == 1)
                    .padding(16)
                }
                ProgressView(value: viewModel.complete)
                    .animation(.linear(duration: viewModel.targetWordDuration), value:  viewModel.complete)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
//        .ignoresSafeArea(edges: .top)
//        .toolbar(viewModel.isPaused ? .visible : .hidden)
        .toolbar(.hidden)
    }
}

struct CompletionView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        VStack {
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.poem.title)
                            .font(.headline)
                        Text(viewModel.poem.author)
                            .font(.subheadline)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("words: \(viewModel.words.count)")
                        Text("time: \(viewModel.runInfo.totalDuration)")
                        Text("average words per minute: \(TimeInterval(viewModel.words.count) * 60 / viewModel.runInfo.totalDuration)")
                    }
                }
                Spacer()
            }
            Spacer()
            Text("Congrats")
                .font(.largeTitle)
            Spacer()
            Button("Ok") {
                viewModel.reset()
            }
        }
        .toolbar(.hidden)
        .padding(32)
    }
}

//#Preview {
//    SpeedReadingView()
//}
