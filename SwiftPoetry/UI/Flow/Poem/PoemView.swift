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
                        .primaryButtonLabelStyle()
                        .frame(maxWidth: .infinity)
                }
                .primaryButtonContainerStyle()
                .padding(16)
            }
            .padding(8)
            .groupedArea()
        }
    }
}

#Preview {
    DefaultPreviewParent {
        PoemView(viewModel: .make(poem: PoetryStubs.shortPoem, dependacySource: $0))
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        PoemView(viewModel: .make(poem: PoetryStubs.veryShortPoem, dependacySource: $0))
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        PoemView(viewModel: .make(poem: PoetryStubs.longPoem, dependacySource: $0))
    }
}
