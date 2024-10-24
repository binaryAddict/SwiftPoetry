//
//  CompletionView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

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
                        Text("time: \(viewModel.runInfo.totalDuration.durationFormatted)")
                        Text("average words per minute: \(NumberFormatter.averageWordsPerMinute.string(for: viewModel.averageWordPerMinute ) ?? "")")
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

#Preview {
    DefaultPreviewParent {
        CompletionView(
            viewModel: .makePreview().with {
                $0.start()
                $0.isPaused = true
                $0.runInfo.wordIndex = $0.words.count - 1
                $0.runInfo.duration += 1
                $0.runInfo.totalDuration = 35
            }
        )
    }
}

#Preview {
    DefaultPreviewParent {
        CompletionView(
            viewModel: .makePreview().with {
                $0.start()
                $0.isPaused = true
                $0.runInfo.wordIndex = $0.words.count - 1
                $0.runInfo.duration += 1
                $0.runInfo.totalDuration = 135
            }
        )
    }
}

