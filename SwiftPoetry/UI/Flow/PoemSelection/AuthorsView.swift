//
//  AuthorsView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorsView: View {
    
    @State var viewModel: AuthorsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.filteredAuthors, id: \.self) { author in
                NavigationLink(value: viewModel.navigationValue(author: author)) {
                    Text(author)
                }
            }
            HStack {
                OfflineOnlyView(settings: viewModel.settings)
                    .padding(16)
                Spacer()
            }
            .groupedArea()
        }
        .navigationTitle("Authors")
        .onAppear(perform: viewModel.onAppear)
        .searchable(text: $viewModel.filter)
        .fetchingOverlay(isFetching: $viewModel.fetching)
        .alert("Error", isPresented: $viewModel.presentNetworkedError) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            Button("Use Offline") {
                viewModel.settings.offlineOnly = true
            }
        } message: {
            Text("Unable to retrieve Authors")
        }
        .alert("Error", isPresented: $viewModel.presentOfflineError) {
            Button("Ok") {
                dismiss()
            }
        } message: {
            Text("Unable to retrieve Authors")
        }
    }
}

#Preview {
    DefaultPreviewParent() {
        AuthorsView(viewModel: .makePreview())
    }
}

#Preview("Delayed Network") {
    DefaultPreviewParent {
        AuthorsView(viewModel: .makePreview(mode: .delayedNetwork))
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        AuthorsView(viewModel: .makePreview(mode: .failingNetwork))
    }
}

#Preview("Failing Offine") {
    DefaultPreviewParent {
        AuthorsView(
            viewModel: .makePreview(mode: .failingOffline).with {
                $0.settings.offlineOnly = true
            }
        )
    }
}
