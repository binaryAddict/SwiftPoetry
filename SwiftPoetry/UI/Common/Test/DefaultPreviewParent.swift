//
//  DefaultPreviewParent.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

struct DefaultPreviewParent<T: View>: View {
    @State var state: Any?
    var content: () -> T
    var body: some View {
        NavigationStack {
            content()
                .navigationDestinations()
                .tint(.appTint)
        }
        .tint(.appTint)
    }
}
