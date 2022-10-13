//
//  LevelView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct LevelView: View {
    @ObservedObject var model: ViewModel
    var level: Level

    @StateObject var levelViewModel: LevelViewModel

    init(model: ViewModel, level: Level) {
        self.model = model
        self.level = level
        self._levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }

    var body: some View {
        VStack {
            if level.challenges.indices.contains(levelViewModel.currentLevelIndex) {
                let challenge = level.challenges[levelViewModel.currentLevelIndex]

                VStack(alignment: .leading) {
                    Text("Verbo:")
                        .font(.headline)

                    Text(challenge.verb)
                        .font(.largeTitle)
                }
                .padding(16)
                .background(UIColor.secondarySystemBackground.color)
                .cornerRadius(16)
                .frame(maxWidth: .infinity, alignment: .leading)

                /// total height = 400
                VStack(spacing: 20) {
                    ForEach(challenge.forms, id: \.self) { form in
                        Button {
                            withAnimation(.spring()) {
                                levelViewModel.currentLevelIndex += 1
                            }

                        } label: {
                            Text(form)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                    }
                }
                .frame(width: 150)
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                Text("All done!")
            }
        }
        .padding(16)
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
