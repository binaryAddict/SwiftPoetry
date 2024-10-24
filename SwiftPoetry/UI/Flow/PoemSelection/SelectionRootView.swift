//
//  SelectionRootView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import SwiftUI

struct SelectionRootView: View {
    @Bindable var viewModel: SelectionRootViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 32) {
                Spacer()
                VStack(spacing: 32) {
                    Text("Pick a Poem")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 16)
                    NavigationLink(value: viewModel.randomPoemNavigation()) {
                        Text("Suprise Me!!")
                            .font(.largeTitle)
                            .padding(8)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    NavigationLink(value: viewModel.authorsNavigationValue()) {
                        Text("Let me choose")
                            .font(.title3)
                    }
                }
                .padding(.vertical, 48)
                .padding(.horizontal, 32)
                .background(Color.white)
                .cornerRadius(16, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .shadow(radius: 10)
                Spacer()
                HStack {
                    OfflineOnlyView(offlineOnly: $viewModel.settings.offlineOnly)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding(16)
                    Spacer()
                }
            }
            
        }
//        .navigationTitle("Pick a Poem")
        .background {
            Image(.backdrop4)
                .resizable()
                .opacity(0.8)
//                .colorMultiply(.init(red: 0.9, green:  0.9, blue:  0.9))
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 4)
            
        }
    }
}

#Preview {
    DefaultPreviewParent {
        SelectionRootView(viewModel: .makePreview())
    }
}

#Preview("Failing Network") {
    DefaultPreviewParent {
        SelectionRootView(viewModel: .makePreview(mode: .failingNetwork))
    }
}
