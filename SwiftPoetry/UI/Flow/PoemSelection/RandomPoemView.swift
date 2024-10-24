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
    @State var loaded = false
    
    var body: some View {
        Group {
            if loaded, let speedReading = viewModel.speedReading {
                PoemView(viewModel: .init(poem: speedReading.poem))
                    .transition(.reveredSlide)
            } else {
                Spacer()
                    .onAppear(perform: viewModel.onAppear)
                    .fetchingOverlay(isFetching: $viewModel.fetching)
            }
        }
        .onChange(of: viewModel.speedReading != nil) { _, newValue in
            withAnimation {
                loaded = newValue
            }
        }
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

#Preview {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .makePreview())
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .makePreview(mode: .failingNetwork))
    }
}
