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
        VStack {
            List {
                Section {
                    ForEach(viewModel.poem.lines.indices, id: \.self) {
                        Text(viewModel.poem.lines[$0])
                            .font(.caption2)
                            .listRowSeparator(.hidden)
                            .padding(0)
                    }
                } header: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.poem.title)
                            .font(.headline)
                        Text(viewModel.poem.author)
                            .font(.subheadline)
                    }
                }
                
            }
            .listStyle(.plain)
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("estimate:")
                        Text("\(viewModel.estimatedDuration.durationFormatted)")
                    }
                }
                .padding([.top, .trailing], 16)
                HStack {
                    Spacer()
                    VStack(spacing: 32) {
                        Button {
                            viewModel.start()
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        NavigationLink("Something else", value: viewModel.selectionRootNavigation())
                    }
                    Spacer()
                }
            }

            .padding(.bottom, 16)
            .background {
                Color.white.ignoresSafeArea(edges: .bottom).shadow(radius: 10)
            }
            
        }
        .navigationTitle("Poem")
    }
}

#Preview {
    NavigationStack {
        PoemView(viewModel: .makePreview())
            .navigationDestinations()
    }
}

#Preview("Very Short Poem") {
    NavigationStack {
        PoemView(viewModel: .makePreview(poem: PoetryStubs.veryShortPoem))
            .navigationDestinations()
    }
}

#Preview("Long Poem") {
    NavigationStack {
        PoemView(viewModel: .makePreview(poem: PoetryStubs.longPoem))
            .navigationDestinations()
    }
}

#Preview("Failing Network") {
    NavigationStack {
        PoemView(viewModel: .makePreview(mode: .failingNetwork))
            .navigationDestinations()
    }
}
