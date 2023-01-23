//
//  LevelViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class LevelViewModel: ObservableObject {
    var level: Level
    var finished = false
    @Published var interactions = [ChallengeInteraction]()

    init(level: Level) {
        self.level = level
    }
}

extension LevelViewModel {
    func start() {
        print("loading.")
        loadNextChallenge()
    }

    func loadNextChallenge() {
        let displayedChallenges = interactions.map { $0.challenge }
        if let nextChallenge = level.challenges.first { !displayedChallenges.contains($0) } {
            let interaction = ChallengeInteraction(challenge: nextChallenge)

            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                interactions.append(interaction)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let index = self.interactionIndex(for: interaction) else {
                    return
                }

                withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    self.interactions[index].step = .sentQuestion
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let index = self.interactionIndex(for: interaction) else {
                    return
                }

                withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                    self.interactions[index].step = .choicesDisplayed
                }
            }

        } else {
            /// no more challenges!

            withAnimation {
                finished = true
            }
        }
    }

    func interactionIndex(for interaction: ChallengeInteraction) -> Int? {
        let index = interactions.firstIndex(of: interaction)
        return index
    }
}
