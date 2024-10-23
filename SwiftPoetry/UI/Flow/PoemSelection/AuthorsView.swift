//
//  AuthorsView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

struct AuthorsView: View {
    @State var isPresented = true
    @Bindable var viewModel: AuthorsViewModel
    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.filteredAuthors, id: \.self) { author in
                NavigationLink(value: viewModel.navigationValue(author: author)) {
                    Text(author)
                }
            }
            
            OfflineOnlyView(offlineOnly: $viewModel.offlineOnly)
                .background(Color.white)
                .shadow(radius: 12)
        }
        .navigationTitle("Authors")
        .onAppear(perform: viewModel.onAppear)
        .searchable(text: $viewModel.filter)
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
