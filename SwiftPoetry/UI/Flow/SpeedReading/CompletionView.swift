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
                        Text("time: \(viewModel.runInfo.totalDuration)")
                        Text("average words per minute: \(TimeInterval(viewModel.words.count) * 60 / viewModel.runInfo.totalDuration)")
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
