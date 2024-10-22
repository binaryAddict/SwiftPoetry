//
//  HomeView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI



@MainActor
@Observable
class HomeViewModel {
    private let poetryService: any PoetryService
    private(set) var poem: Poem?
    init(poetryService: any PoetryService = .shared) {
        self.poetryService = poetryService
    }
    func onAppear() {
        fetchRandomPoem()
    }
    
    func fetchRandomPoem() {
        DispatchQueue.main.asyncAwait {
            try await self.poetryService.randomPoem()
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
