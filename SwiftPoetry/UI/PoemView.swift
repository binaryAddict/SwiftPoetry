//
//  PoemView.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 21/10/2024.
//

import SwiftUI
import Combine

struct PoemView: View {
    let viewModel: SpeedReadingViewModel
    var body: some View {
        VStack {
            List {
                
                Section {
                    ForEach(viewModel.poem.lines.indices, id: \.self) {
                        Text(viewModel.poem.lines[$0])
                            .font(.caption2)
                            .listRowSeparator(.hidden)
//                            .listRowSpacing(0)
                            .padding(0)
                    }
                    .listRowSeparator(.hidden)
//                    .listRowSpacing(0)
                } header: {
                    VStack(alignment: .leading) {
                        Text(viewModel.poem.title)
                            .font(.headline)
                        Text(viewModel.poem.author)
                            .font(.subheadline)
                    }            }
            }
//            .listRowSpacing(0)
            //        .list
            .listStyle(.plain)
            HStack {
                Spacer()
                Button {
                    self.viewModel.start()
                } label: {
                    Image(systemName: "play")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Spacer()
            }
            .padding(32)
            .background(Color.white)
            .shadow(radius: 10)
        }
//        .listRowSeparatorTint(.clear)
        
    }
}

#Preview {
    PoemView(
        viewModel: .init(
            poem: Poem(title: "My First", author: "Some One", lines: ["This is my first poem.", "The End"])
        )
    )
}

