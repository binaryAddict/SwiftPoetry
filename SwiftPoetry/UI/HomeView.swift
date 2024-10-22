//
//  HomeView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

@MainActor
@Observable
class HomeViewModel: ObservableObject {
    
    @ObservationIgnored @AppStorage(AppStorageKey.offlineOnly.rawValue) var offlineOnly = AppStorageDefaultValue.offlineOnly 
    {
        didSet {
            fetchRandomPoem()
        }
    }
    private let poetryServiceProvider: PoetryServiceProvider
    private(set) var poem: Poem?
    private(set) var fetching = false
    var disabled : Bool {
        fetching || poem == nil
    }
    
    init(poetryService: PoetryServiceProvider = .shared) {
        self.poetryServiceProvider = poetryService
    }
    
    func onAppear() {
        fetchRandomPoem()
    }
    
    func fetchRandomPoem() {
        let offlineOnly = self.offlineOnly
        fetching = true
        DispatchQueue.main.asyncAwait {
            try await self.poetryServiceProvider.service(offlineOnly: offlineOnly).randomPoem()
        } completion: { [weak self] result in
            guard let self else { return }
            self.fetching = false
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
    @Bindable var viewModel: HomeViewModel
    var body: some View {
        NavigationLink(value: viewModel.poemNavigationValue()) {
            ZStack {
                VStack(alignment: .center) {
                    Text("Suprise Me!!")
                    HStack(spacing: 16) {
                        Text("Offline only")
                        Toggle("Offline only", isOn: $viewModel.offlineOnly)
                            .labelsHidden()
                    }
                }
                .padding(16)
                if viewModel.fetching {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            Color.white.opacity(0.7)
                        }
                }
            }
        }
        .disabled(viewModel.disabled)
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
