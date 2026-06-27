//
//  AllListsView.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/27/26.
//  Copyright © 2026 Leandro Rocha. All rights reserved.
//

import SwiftUI

struct AllListsView: View {
    
    // TODO: Migrate word list data model
    @State private var wordLists: [WordList] = [
        .init(title: "World Cup Teams"),
        .init(title: "NFL Teams")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(wordLists, id: \.self.title) { wordList in
                    VStack(alignment: .leading) {
                        Text(wordList.title)
                        Text(wordList.wordCountDescription)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Word Lists")
            .toolbar {
                Button {
                    // TODO: Implement add functionality
                    print("Add new word list")
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    AllListsView()
}
