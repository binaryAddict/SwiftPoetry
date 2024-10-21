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
         60 / TimeInterval(wordPerMinute)
    }
    var currentWord: Substring {
        currentLine[wordIndex]
    }
    var complete: Float {
        let lastWord: Float = duration >= wordDuration ? 1 : 0
        let currentLine = (lastWord + Float(wordIndex)) / Float(currentLine.count)
        return (currentLine + Float(lineIndex)) / Float(poem.lines.count)
    }
    
    let poem: Poem
    private var _wordPerMinute = 240
    var wordPerMinute: Int {
        get {
            _wordPerMinute
        }
        set {
            _wordPerMinute = min(WordPerMinute.max, max(WordPerMinute.min, newValue))
        }
    }
    
    private(set) var wordIndex = 0
    private(set) var lineIndex = -1
    private(set) var finished = false
    private(set) var currentLine: [Substring] = [""]
    
    private var duration = TimeInterval(0)
    private let displayLink = DisplayLinkController(paused: true)
    private var token: Any?
    
    init(poem: Poem) {
        self.poem = poem
        nextWord()
        token = displayLink.update.sink { [weak self] change in
            guard let self else { return }
            duration += change.duration
            guard duration > wordDuration, complete != 1 else { return }
            duration -= wordDuration
            nextWord()
        }
    }
    
    func onAppear() {
        displayLink.paused = false
    }
    
    func nextWord() {
        if wordIndex < currentLine.count - 1 {
            wordIndex += 1
            return
        }
        guard lineIndex < poem.lines.count - 1 else {
            return
        }
        lineIndex += 1
        wordIndex = 0
        currentLine = poem.lines[lineIndex].split(separator: " ")
        if currentLine.isEmpty {
            currentLine.append("")
        }
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
                        Text("\(viewModel.wordPerMinute)")
                        HStack(spacing: 16) {
                            Button {
                                viewModel.wordPerMinute -= 10
                            } label: {
                                Image(systemName: "minus")
                            }
                            .disabled(viewModel.wordPerMinute == WordPerMinute.min)
                            Button {
                                viewModel.wordPerMinute += 10
                            } label: {
                                Image(systemName: "plus")
                            }
                            .disabled(viewModel.wordPerMinute == WordPerMinute.max)
                        }
                    }
                    .disabled(viewModel.complete == 1)
                    .padding(16)
                }
                ProgressView(value: viewModel.complete)
                    .animation(.easeInOut(duration: viewModel.wordDuration), value:  viewModel.complete)
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
