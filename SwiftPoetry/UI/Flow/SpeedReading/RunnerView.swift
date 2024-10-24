//
//  RunnerView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

private extension Image {
    func imageSize(_ size: CGFloat) -> some View {
        resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: size, height: size)
    }
}

struct RunnerView: View {
    
    @State var viewModel: SpeedReadingViewModel
    @State private var wordsPerMinuteOpacity = 0.0
    
    var body: some View {
        ZStack {
            Text(viewModel.currentWord)
                .font(.title2)
            VStack {
                Spacer()
                
                Text("\(viewModel.settings.wordsPerMinute.value) words per minute")
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        Color.gray.clipShape(Capsule())
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
                                .imageSize(20)
                        }
                        .disabled(viewModel.settings.wordsPerMinute.value == WordsPerMinute.min)
                        Spacer()

                        Button {
                            viewModel.isPaused.toggle()
                        } label: {
                            Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                .imageSize(30)
                        }
                        .id(viewModel.isPaused ? "pausedButton" : "playButton")
                        
                        Spacer()
                        Button {
                            viewModel.settings.wordsPerMinute.value += 10
                        } label: {
                            Image(systemName: "plus")
                                .imageSize(20)
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
                        .clipShape(Capsule())
                        .shadow(radius: 10)
                }
                .padding(16)
                
                ProgressView(value: viewModel.complete)
                    .shadow(radius: 10)
                    .padding(.horizontal, 48)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview()
        )
    }
}

#Preview("Paused") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview().with { vm in
                DispatchQueue.main.async {
                    vm.isPaused = true
                }
            }
        )
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview(poem: PoetryStubs.veryShortPoem)
        )
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        RunnerView(
            viewModel: .makePreview(poem: PoetryStubs.longPoem)
        )
    }
}
