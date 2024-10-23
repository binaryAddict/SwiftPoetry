//
//  SpeedReadingView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct SpeedReadingView: View {
    @State var viewModel: SpeedReadingViewModel
    var body: some View {
        if viewModel.runInfo.started == false {
            PoemView(viewModel: viewModel)
        } else {
            if viewModel.complete == 1 {
                CompletionView(viewModel: viewModel)
            } else {
                RunnerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpeedReadingView(viewModel: .makePreview())
            .navigationDestinations()
    }
}

#Preview("Very Short Poem") {
    NavigationStack {
        SpeedReadingView(viewModel: .makePreview(poem: PoetryStubs.veryShortPoem))
            .navigationDestinations()
    }
}

#Preview("Long Poem") {
    NavigationStack {
        SpeedReadingView(viewModel: .makePreview(poem: PoetryStubs.longPoem))
            .navigationDestinations()
    }
}

#Preview("Failing Network") {
    NavigationStack {
        SpeedReadingView(viewModel: .makePreview(mode: .failingNetwork))
            .navigationDestinations()
    }
}
