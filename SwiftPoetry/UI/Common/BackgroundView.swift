//
//  BackgroundView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 24/10/2024.
//

import SwiftUI

struct BackgroundView: View {
    
    var appStyle: AppStyle = .current
    
    var body: some View {
        if appStyle == .modern {
            Image(.modernBackdrop)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        } else {
            Image(appStyle == .traditionalA ? .traditionalBackdropA : .traditionalBackdropB)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .opacity(0.8)
                .blur(radius: 4)
        }
    }
}

#Preview {
    BackgroundView(appStyle: .current)
}

#Preview {
    BackgroundView(appStyle: .modern)
}

#Preview {
    BackgroundView(appStyle: .traditionalA)
}

#Preview {
    BackgroundView(appStyle: .traditionalB)
}
