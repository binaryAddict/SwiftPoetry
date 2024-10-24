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
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .makePreview())
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .makePreview(poem: PoetryStubs.veryShortPoem))
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .makePreview(poem: PoetryStubs.longPoem))
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .makePreview(mode: .failingNetwork))
    }
}
