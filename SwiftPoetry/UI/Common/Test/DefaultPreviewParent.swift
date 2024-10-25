//
//  DefaultPreviewParent.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

struct DefaultPreviewParent<T: View>: View {
    private var dependacySource = DependacySource(
        poetryServiceProvider: .offlineOnly,
        settings: .makeUnbacked()
    )
    
    var content: (DependacySource) -> T
    
    init(content:  @escaping (DependacySource) -> T, with: @escaping (inout DependacySource) -> Void = { _ in } ) {
        self.content = content
        with(&dependacySource)
    }
    
    init(content: @escaping () -> T) {
        self.content = { _ in
            content()
        }
    }
    
    var body: some View {
        NavigationStack {
            content(dependacySource)
                .navigationDestinations(dependacySource: dependacySource)
        }
        .tint(.appTint)
    }
}
