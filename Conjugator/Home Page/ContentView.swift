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
                    HStack {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                                model.selectedLevel = nil
                            }
                        } label: {
                            Image(systemName: "chevron.backward")

                                .fontWeight(.medium)
                                .padding(.trailing, 16)
                                .padding(.vertical, 16)
                                .contentShape(Rectangle())
                                .font(.title3)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Text(selectedLevel.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
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
                let color: Color = {
                    if let selectedLevel = model.selectedLevel, let hex = selectedLevel.colorHex {
                        return UIColor(hex: hex).getTextColor(backgroundIsDark: false).color
                    } else {
                        return Color.blue
                    }
                }()

                color

                    .ignoresSafeArea()
            }

            if let selectedLevel = model.selectedLevel {
                LevelView(model: model, level: selectedLevel)
                    .transition(.offset(x: 20).combined(with: .opacity))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        Text(model.csv)

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
        .onAppear {
            Task {
                await model.loadLevels()
            }
        }
    }
}
