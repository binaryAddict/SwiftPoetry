//
//  CompletionView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

private extension SpeedReadingViewModel {
    var gridContent: [(String, String)] {
        [
            ("words/min:", "\(NumberFormatter.averageWordsPerMinute.string(for: averageWordPerMinute ) ?? "")"),
            ("words:", "\(words.count)"),
            ("time:", "\(runInfo.totalDuration.durationFormatted)"),
        ]
    }
}

struct CompletionView: View {
    @State var viewModel: SpeedReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 32) {
                Text("Well Done")
                    .font(.largeTitle)
                    .foregroundStyle(Color.appTint)
                    .bold()
                
                VStack(spacing: 8) {
                    Text(viewModel.poem.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(viewModel.poem.author)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                Grid(alignment: .leading) {
                    ForEach(viewModel.gridContent, id: \.0) { val in
                        GridRow {
                            Text(val.0)
                            Text(val.1)
                                .foregroundStyle(Color.appTint)
                                .bold()
                                .gridColumnAlignment(.trailing)
                        }
                    }
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 32)
            .groupedArea()
            
            Spacer()
        
            Button {
                dismiss()
            } label: {
                Text("Ok")
                    .primaryButtonLabelStyle()
                    .frame(maxWidth: .infinity)
            }
            .primaryButtonContainerStyle()
        }
        .toolbar(.hidden)
        .padding(16)
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    DefaultPreviewParent {
        CompletionView(
            viewModel: .make(poem: PoetryStubs.shortPoem, dependacySource: $0).with {
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
            viewModel: .make(poem: PoetryStubs.shortPoem, dependacySource: $0).with {
                $0.runInfo.wordIndex = $0.words.count - 1
                $0.runInfo.duration += 1
                $0.runInfo.totalDuration = 135
            }
        )
    }
}

