//
//  RandomView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct RandomPoemView: View {
    @State var viewModel: RandomPoemViewModel
    var body: some View {
        if let speedReading = viewModel.speedReading {
            SpeedReadingView(viewModel: speedReading)
        } else {
            Spacer()
                .onAppear(perform: viewModel.onAppear)
                .fetchingOverlay(isFetching: $viewModel.fetching)
        }
        
    }
}

#Preview {
    NavigationStack {
        RandomPoemView(viewModel: .makePreview())
            .navigationDestinations()
    }
}
