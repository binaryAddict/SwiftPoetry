//
//  AuthorView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorPoemsView: View {
    @Bindable var viewModel: AuthorPoemsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Poems") {
                ForEach(viewModel.filteredPoems, id: \.title) { poem in
                    NavigationLink(value: viewModel.navigationValue(poem: poem)) {
                        Text(poem.title)
                    }
                }
            }
        }
        .searchable(text: $viewModel.filter)
        .navigationTitle(viewModel.author)
        .fetchingOverlay(isFetching: $viewModel.fetching)
        .onAppear(perform: viewModel.onAppear)
        .alert("Error", isPresented: $viewModel.presentError) {
            Button("Ok") {
                dismiss()
            }
        } message: {
            Text("Unable to retrieve poems")
        }
    }
}

#Preview {
    DefaultPreviewParent() {
        AuthorPoemsView(viewModel: .make(author: PoetryStubs.authorJonathanSwift, dependacySource: $0))
    }
}

#Preview("Delayed Network") {
    DefaultPreviewParent {
        AuthorPoemsView(viewModel: .make(author: PoetryStubs.authorJonathanSwift, dependacySource: $0))
    } with: {
        $0.poetryServiceProvider = .delayedNetwork
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        AuthorPoemsView(viewModel: .make(author: PoetryStubs.authorJonathanSwift, dependacySource: $0))
    }  with: {
        $0.poetryServiceProvider = .failingNetwork
    }
}
