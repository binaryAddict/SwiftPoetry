//
//  RunnerView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct RunnerView: View {

    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        ZStack {
            Text(viewModel.currentWord)
                .font(.title2)
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
                       
                        .frame(idealWidth: .infinity)
                        .layoutPriority(1)
                    Button {
                        viewModel.isPaused.toggle()
                    } label: {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                    }
                    
                    .padding(16)
                    .frame(idealWidth: .infinity)
                    .layoutPriority(1)
//                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(viewModel.settings.wordsPerMinute.value)")
                            .opacity(viewModel.isPaused ? 1 : 0)
                        HStack(spacing: 16) {
                            Button {
                                viewModel.settings.wordsPerMinute.value -= 10
                            } label: {
                                Image(systemName: "minus")
                            }
                            .disabled(viewModel.settings.wordsPerMinute.value == WordsPerMinute.min)
                            Button {
                                viewModel.settings.wordsPerMinute.value += 10
                            } label: {
                                Image(systemName: "plus")
                            }
                            .disabled(viewModel.settings.wordsPerMinute.value == WordsPerMinute.max)
                        }
                    }
                    .disabled(viewModel.complete == 1)
                    .padding(16)
                    .frame(idealWidth: .infinity)
                    .layoutPriority(1)
                }
                .frame(idealWidth: .infinity)
                ProgressView(value: viewModel.complete)
                    .animation(.linear(duration: viewModel.targetWordDuration), value:  viewModel.complete)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview().with {
                $0.start()
            }
        )
    }
}

#Preview("Paused") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview().with {
                $0.start()
                $0.isPaused = true
            }
        )
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview(poem: PoetryStubs.veryShortPoem).with {
                $0.start()
            }
        )
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview(poem: PoetryStubs.longPoem).with {
                $0.start()
            }
        )
    }
}
