//
//  RunnerView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct RunnerView: View {
    
    @State var viewModel: SpeedReadingViewModel
    @State private var wordsPerMinuteOpacity = 0.0
    
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
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .padding(16)
                }
                Spacer()
            }
            VStack {
                Spacer()
                Text("\(viewModel.settings.wordsPerMinute.value) words per minute")
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        Color.gray.cornerRadius(24).shadow(radius: 4)
                    }
                    .opacity(wordsPerMinuteOpacity)
                    .onChange(of: viewModel.settings.wordsPerMinute.value) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            wordsPerMinuteOpacity = 0.9
                        } completion: {
                            withAnimation(.easeInOut(duration: 0.5).delay(1.5)) {
                                wordsPerMinuteOpacity = 0.0
                            }
                        }
                    }
                VStack(spacing: 16) {
                    HStack {
                        Button {
                            viewModel.settings.wordsPerMinute.value -= 10
                        } label: {
                            Image(systemName: "minus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                        .disabled(viewModel.settings.wordsPerMinute.value == WordsPerMinute.min)
                        Spacer()
                        Button {
                            viewModel.isPaused.toggle()
                        } label: {
                            Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        Spacer()
                        Button {
                            viewModel.settings.wordsPerMinute.value += 10
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                        .disabled(viewModel.settings.wordsPerMinute.value == WordsPerMinute.max)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 32)
                .tint(.white)
                .background {
                    Color
                        .appTint
                        .cornerRadius(64)
                        .shadow(radius: 8)
                }
                .padding(16)
                ProgressView(value: viewModel.complete)
                    .animation(.linear(duration: viewModel.targetWordDuration), value:  viewModel.complete)
                    .shadow(radius: 8)
                    .padding(.horizontal, 48)
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
