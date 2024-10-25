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
        VStack(alignment: .center, spacing: 32) {
            Spacer()
            VStack(spacing: 32) {
                Text("Pick a Poem")
                    .font(.largeTitle)
                    .bold()
                Text("Improve your reading speed\nwhile reading poetry")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .padding(.bottom, 16)
                NavigationLink(value: viewModel.randomPoemNavigation()) {
                    Text("Suprise Me")
                        .primaryButtonLabelStyle()
                }
                .primaryButtonContainerStyle()
                
                NavigationLink(value: viewModel.authorsNavigationValue()) {
                    Text("Let me choose")
                        .font(.title3)
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 32)
            .groupedArea()
            .padding(16)
            
            Spacer()
            HStack {
                OfflineOnlyView(settings: viewModel.settings)
                    .padding(16)
                    .groupedArea()
                    .padding(16)
                Spacer()
            }
        }
        .background {
            BackgroundView()
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
