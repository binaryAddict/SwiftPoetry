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
    private let poetryService: PoetryService
    
    init(poetryService: PoetryService = .shared) {
        self.poetryService = poetryService
    }
    
    func onAppear() {
        DispatchQueue.main.asyncAwait {
            try await self.poetryService.authors()
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
        AuthorNavigation(author: author, poetryService: poetryService)
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
