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
    
    init(poem: Poem) {
        self.poem = poem
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
    
    func start() {
        runInfo = .init()
        runInfo.started = true
        isPaused = false
    }
}

struct RunnerView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        ZStack {
            Text(viewModel.currentWord)
                .font(.title2)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text("Finished")
                        .opacity(viewModel.complete == 1 ? 1 : 0)
                    Spacer()
                    Button {
                        viewModel.isPaused.toggle()
                    } label: {
                        Image(systemName: viewModel.isPaused ? "play" : "pause")
                    }
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
        .ignoresSafeArea(edges: .top)
        .toolbar(viewModel.isPaused ? .visible : .hidden)
    }
}

struct CompletionView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        Text("Done")
    }
}

//#Preview {
//    SpeedReadingView()
//}
