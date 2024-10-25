//
//  SpeedReadingView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct SpeedReadingView: View {
    @State var viewModel: SpeedReadingViewModel
    @State private var complete = 0.0
    
    var body: some View {
        Group {
            if complete == 1 {
                CompletionView(viewModel: viewModel).transition(.reveredSlide)
            } else {
                RunnerView(viewModel: viewModel).transition(.reveredSlide)
            }
        }
        .onChange(of: viewModel.complete) {  _, newValue in
            withAnimation(.easeInOut(duration: 0.4)) {
                complete = newValue
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
