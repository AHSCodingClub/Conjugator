//
//  ContentView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModel()

    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(model.levels, id: \.title) { level in
                        NavigationLink(destination: LevelView(model: model, level: level)) {
                            LevelCardView(level: level)
                        }
                    }
                }
                .padding()
            }
            .background(UIColor.secondarySystemBackground.color)
            .navigationTitle("Conjugator")
        }
    }
}
