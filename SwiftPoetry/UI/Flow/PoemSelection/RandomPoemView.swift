//
//  RandomView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 23/10/2024.
//

import SwiftUI

struct RandomPoemView: View {
    @State var viewModel: RandomPoemViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let speedReading = viewModel.speedReading {
            SpeedReadingView(viewModel: speedReading)
        } else {
            Spacer()
                .onAppear(perform: viewModel.onAppear)
                .fetchingOverlay(isFetching: $viewModel.fetching)
                .alert("Error", isPresented: $viewModel.presentError) {
                    if viewModel.settings.offlineOnly {
                        Button("Ok") {
                            dismiss()
                        }
                    } else {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                        Button("Use Offline") {
                            viewModel.settings.offlineOnly = true
                            viewModel.fetchRandomPoem()
                        }
                    }
                } message: {
                    Text("Unable to retrieve a Poem")
                }
        }
        
    }
}

#Preview {
    NavigationStack {
        RandomPoemView(viewModel: .makePreview())
            .navigationDestinations()
    }
}

#Preview("Failing Network") {
    NavigationStack {
        RandomPoemView(viewModel: .makePreview(mode: .failingNetwork))
            .navigationDestinations()
    }
}
