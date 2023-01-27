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
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                if let selectedLevel = model.selectedLevel {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                            model.selectedLevel = nil
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "chevron.backward")
                                .fontWeight(.medium)

                            Text("Back")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .font(.title3)
                    }
                } else {
                    Text("Conjugator")
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.heavy))
                        .padding(.vertical, 24)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                Color.blue
                    .ignoresSafeArea()
            }

            if let selectedLevel = model.selectedLevel {
                LevelView(model: model, level: selectedLevel)
                    .transition(.offset(x: 20).combined(with: .opacity))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(model.levels, id: \.title) { level in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                                    model.selectedLevel = level
                                }
                            } label: {
                                LevelCardView(level: level)
                            }
                        }
                    }
                    .padding()
                }
                .background(UIColor.secondarySystemBackground.color)
                .transition(.offset(x: -20).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
