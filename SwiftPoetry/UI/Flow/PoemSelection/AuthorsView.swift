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
                }
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

#Preview("Failing Network") {
    DefaultPreviewParent {
        AuthorsView(viewModel: .makePreview(mode: .failingNetwork))
    }
}
