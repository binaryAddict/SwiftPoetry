//
//  PoemView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI
import Combine

struct PoemView: View {
    let poem: Poem
    var body: some View {
        List(poem.lines.indices, id: \.self) {
            Text(poem.lines[$0])
        }
    }
}

#Preview {
    PoemView(poem: Poem(title: "My First", author: "Some One", lines: ["This is my first poem.", "The End"]))
}

enum WordPerMinute {
    static let min = 15
    static let max = 60 * 15
}

