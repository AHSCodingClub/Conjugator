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
                        LevelCardView(level: level)
                    }
                }
                .padding()
            }
            .background(UIColor.secondarySystemBackground.color)
            .navigationTitle("Conjugator")
        }
    }
}

struct LevelCardView: View {
    var level: Level

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(level.title)

                Spacer()

                Image(systemName: "chevron.forward")
            }
            .font(.title3)
            .padding(16)
            .background {
                if let colorHex = level.colorHex {
                    UIColor(hex: colorHex).color.opacity(0.25)
                } else {
                    Color.black.opacity(0.25)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(level.description)
                    .font(.title3)
                    .foregroundColor(UIColor.secondaryLabel.color)

                Text("Contains \(level.challenges.count) verbs")
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(UIColor.systemBackground.color)
        .cornerRadius(16)
    }
}
