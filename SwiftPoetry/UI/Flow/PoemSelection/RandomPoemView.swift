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
            if loaded, let poem = viewModel.poem {
                PoemView(viewModel: .init(poem: poem, settings: viewModel.settings))
                    .transition(.reveredSlide)
            } else {
                Spacer()
                    .onAppear(perform: viewModel.onAppear)
                    .fetchingOverlay(isFetching: $viewModel.fetching)
            }
        }
        .onChange(of: viewModel.poem != nil) { _, newValue in
            withAnimation {
                loaded = newValue
            }
        }
        .alert("Error", isPresented: $viewModel.presentNetworkedError) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            Button("Use Offline") {
                viewModel.settings.offlineOnly = true
                viewModel.fetchRandomPoem()
            }
        } message: {
            Text("Unable to retrieve a Poem")
        }
        .alert("Error", isPresented: $viewModel.presentOfflineError) {
            Button("Ok") {
                dismiss()
            }
        } message: {
            Text("Unable to retrieve a Poem")
        }
        
    }
}

#Preview {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .make(dependacySource: $0))
    }
}

#Preview("Delayed Network") {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .make(dependacySource: $0))
    } with: {
        $0.poetryServiceProvider = .delayedNetwork
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .make(dependacySource: $0))
    } with: {
        $0.poetryServiceProvider = .failingNetwork
    }
}

#Preview("Failing Offline") {
    DefaultPreviewParent {
        RandomPoemView(viewModel: .make(dependacySource: $0))
    } with: {
        $0.poetryServiceProvider = .failingOffline
        $0.settings.offlineOnly = true
    }
}
