//
//  AuthorView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

@MainActor
@Observable
class AuthorViewModel {
    private(set) var fetching = false
    let author: String
    var filter = ""
    var filteredPoems: [Poem] {
        filter.isEmpty ? peoms : peoms.filter { $0.title.localizedCaseInsensitiveContains(filter) }
    }
    private(set) var peoms: [Poem] = []
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(author: String, poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.author = author
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func onAppear() {
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service().poems(author: self.author)
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.peoms = val
            case .failure:
                break
            }
        }
    }
    
    func navigationValue(poem: Poem) -> some Hashable {
        SpeedReederNavigation(poem: poem, poetryServiceProvider: poetryServiceProvider)
    }
}


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
    AuthorView(viewModel: .init(author: "SSS"))
}