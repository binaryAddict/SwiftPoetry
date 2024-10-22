//
//  HomeView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

enum ServiceError: Error {
    case missingData
}

@MainActor
@Observable
class HomeViewModel {
    private let poetryService: PoetryService
    private(set) var poem: Poem?
    init(poetryService: PoetryService = .shared) {
        self.poetryService = poetryService
    }
    func onAppear() {
        fetchRandomPoem()
    }
    
    func fetchRandomPoem() {
        DispatchQueue.main.asyncAwait {
            let authors = try await self.poetryService.authors()
            guard let author = authors.randomElement() else {
                throw ServiceError.missingData
            }
            let poems = try await self.poetryService.poems(author: author)
            guard let poem = poems.randomElement() else {
                throw ServiceError.missingData
            }
            return poem
        } completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let poem):
                self.poem = poem
            case .failure:
                break
            }
        }
    }
    
    func poemNavigationValue() -> (some Hashable)? {
        poem
    }
}

struct HomeView: View {
    @State var viewModel: HomeViewModel
    var body: some View {
        NavigationLink(value: viewModel.poemNavigationValue()) {
            Text("Suprise Me!!")
        }
        .disabled(viewModel.poemNavigationValue() == nil)
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
