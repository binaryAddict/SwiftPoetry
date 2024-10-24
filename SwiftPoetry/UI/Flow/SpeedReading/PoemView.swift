//
//  PoemView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI
import Combine

struct PoemView: View {
    let viewModel: SpeedReadingViewModel
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.poem.title)
                            .font(.headline)
                        Text(viewModel.poem.author)
                            .font(.subheadline)
                    }
                    HStack {
                        Spacer()
                        Text("estimate: \(viewModel.estimatedDuration.durationFormatted)")
                            .font(.footnote)
                    }
                    .padding(.bottom, 32)
                    ForEach(viewModel.poem.lines.indices, id: \.self) {
                        Text(viewModel.poem.lines[$0])
                            .padding(0)

                    }
                }
                .padding(32)
            }
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Button {
                        viewModel.start()
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(16)
                    NavigationLink("Something else", value: viewModel.selectionRootNavigation())
                }
                Spacer()
            }
            .padding(.top, 32)
            .padding(.bottom, 16)
            .background {
                Color.white
                    .cornerRadius(32)
                    .ignoresSafeArea(edges: .bottom)
                    .shadow(radius: 10)
            }
        }
        .navigationTitle("Poem")
    }
}

#Preview {
    DefaultPreviewParent {
        PoemView(viewModel: .makePreview())
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        PoemView(viewModel: .makePreview(poem: PoetryStubs.veryShortPoem))
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        PoemView(viewModel: .makePreview(poem: PoetryStubs.longPoem))
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        PoemView(viewModel: .makePreview(mode: .failingNetwork))
    }
}
