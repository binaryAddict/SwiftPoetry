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
                // Some authors repeat titles particularly since some poems are letters; hence using indices
                let filteredPoems = viewModel.filteredPoems
                ForEach(filteredPoems.indices, id: \.self) { i in
                    NavigationLink(value: viewModel.navigationValue(poem: filteredPoems[i])) {
                        Text(filteredPoems[i].title)
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
