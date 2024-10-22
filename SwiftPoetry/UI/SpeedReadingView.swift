//
//  SpeedReadingView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

@MainActor
@Observable
class SpeedReadingViewModel {
    
    var wordDuration: TimeInterval {
        60 / TimeInterval(wordPerMinute.value)
    }
    var currentWord: Substring {
        words[wordIndex]
    }
    var complete: Float {
        let lastWord: Float = duration >= wordDuration ? 1 : 0
        return (lastWord + Float(wordIndex)) / Float(words.count)
    }
    
    let poem: Poem
    let words: [Substring]
    @ObservationIgnored @AppStorage(AppStorageKey.wordsPerMinute.rawValue) var wordPerMinute = AppStorageDefaultValue.wordsPerMinute
    private(set) var wordIndex = 0
    
    private var duration = TimeInterval(0)
    private let displayLink = DisplayLinkController(paused: true)
    private var token: Any?
    
    init(poem: Poem) {
        self.poem = poem
        self.words = poem.lines.flatMap {
            $0.split(separator: " ")
        }
        token = displayLink.update.sink { [weak self] change in
            guard let self else { return }
            duration += change.duration
            guard duration > wordDuration, complete != 1 else { return }
            
            duration -= wordDuration
            wordIndex += 1
        }
    }
    
    func onAppear() {
        displayLink.paused = false
    }
}

struct SpeedReadingView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        if viewModel.complete == 1 {
            CompletionView(viewModel: viewModel)
        } else {
            RunnerView(viewModel: viewModel)
        }
    }
}

struct RunnerView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        ZStack {
            Text(viewModel.currentWord)
                .font(.title2)
            VStack {
                Spacer()
                HStack {
                    Text("Finished")
                        .opacity(viewModel.complete == 1 ? 1 : 0)
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(viewModel.wordPerMinute.value)")
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
                    .animation(.linear(duration: viewModel.wordDuration), value:  viewModel.complete)
            }
        }
        .onAppear(perform: viewModel.onAppear)
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
