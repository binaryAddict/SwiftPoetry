//
//  AuthorsView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorsView: View {
    
    @Bindable var viewModel: AuthorsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.filteredAuthors, id: \.self) { author in
                NavigationLink(value: viewModel.navigationValue(author: author)) {
                    Text(author)
                }
            }
            
            OfflineOnlyView(offlineOnly: $viewModel.settings.offlineOnly)
                .background(Color.white)
                .shadow(radius: 12)
        }
        .navigationTitle("Authors")
        .onAppear(perform: viewModel.onAppear)
        .searchable(text: $viewModel.filter)
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
                    viewModel.fetchAuthors()
                }
            }
        } message: {
            Text("Unable to retrieve Authors")
        }
    }
}

#Preview {
    NavigationStack {
        AuthorsView(viewModel: .makePreview())
            .navigationDestinations()
    }
}


#Preview("Failing Network") {
    NavigationStack {
        AuthorsView(viewModel: .makePreview(mode: .failingNetwork))
            .navigationDestinations()
    }
}
