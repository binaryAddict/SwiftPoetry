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
            .background(Color.white)
            .cornerRadius(16, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .shadow(radius: 10)
            
            Spacer()
        
            Button {
                viewModel.reset()
            } label: {
                Text("Ok")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(32)
            .shadow(radius: 10)
        }
        .toolbar(.hidden)
        .padding(16)
        .background {
            Image(.backdrop4)
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 4)
        }
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

