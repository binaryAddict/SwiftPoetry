//
//  AuthorView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorView: View {
    @Bindable var viewModel: AuthorViewModel
    
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
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    NavigationStack {
        AuthorView(viewModel: .makePreview())
            .navigationDestinations()
    }
}
