//
//  PoemView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI
import Combine

struct PoemView: View {
    let viewModel: PoemViewModel
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
                            .bold()
                            .foregroundStyle(Color.appTint)
                            .font(.footnote)
                    }
                    .padding(.bottom, 32)
                    ForEach(viewModel.poem.lines.indices, id: \.self) {
                        Text(viewModel.poem.lines[$0])
                    }
                }
                .padding(32)
            }
            
            HStack {
                NavigationLink(value: viewModel.speedReederNavigation()) {
                    Text("Start")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(32)
                .shadow(radius: 10)
                .padding(16)
            }
            .padding(8)
            .background {
                Color.white
                    .cornerRadius(32)
                    .ignoresSafeArea(edges: .bottom)
                    .shadow(radius: 10)
            }
        }
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
