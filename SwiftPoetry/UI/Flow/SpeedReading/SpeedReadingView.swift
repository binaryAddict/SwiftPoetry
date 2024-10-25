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
        SpeedReadingView(viewModel: .make(poem: PoetryStubs.shortPoem, dependacySource: $0))
    }
}

#Preview("Very Short Poem") {
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .make(poem: PoetryStubs.veryShortPoem, dependacySource: $0))
    }
}

#Preview("Long Poem") {
    DefaultPreviewParent {
        SpeedReadingView(viewModel: .make(poem: PoetryStubs.longPoem, dependacySource: $0))
    }
}
