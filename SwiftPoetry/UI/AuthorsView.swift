//
//  AuthorsView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI

@MainActor
@Observable
class AuthorsViewModel {
    private(set) var fetching = false
    private(set) var authors: [String] = []
    private(set) var peom: Poem?
    private let poetryServiceProvider: PoetryServiceProvider
    
    init(poetryServiceProvider: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryServiceProvider
    }
    
    func onAppear() {
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service().authors()
        } completion: { [weak self] val in
            guard let self else { return }
            self.fetching = false
            switch val {
            case .success(let val):
                self.authors = val
            case .failure:
                break
            }
        }
    }
    
    func navigationValue(author: String) -> some Hashable {
        AuthorNavigation(author: author, poetryServiceProvider: poetryServiceProvider)
    }
}

struct AuthorsView: View {
    let viewModel: AuthorsViewModel
    var body: some View {
        List(viewModel.authors, id: \.self) { author in
            NavigationLink(value: viewModel.navigationValue(author: author)) {
                Text(author)
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    AuthorsView(viewModel: .init())
}
