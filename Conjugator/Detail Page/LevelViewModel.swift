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
    @Published var conversations = [Conversation]()

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
        let displayedChallenges = conversations.map { $0.challenge }
        if let nextChallenge = level.challenges.first { !displayedChallenges.contains($0) } {
            let conversation = Conversation(challenge: nextChallenge)

            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                conversations.append(conversation)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let index = self.interactionIndex(for: conversation) else {
                    return
                }

                withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    self.conversations[index].step = .sentQuestion
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let index = self.interactionIndex(for: conversation) else {
                    return
                }

                withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                    self.conversations[index].step = .choicesDisplayed
                }
            }

        } else {
            /// no more challenges!

            withAnimation {
                finished = true
            }
        }
    }
    

    func interactionIndex(for interaction: Conversation) -> Int? {
        let index = conversations.firstIndex(of: interaction)
        return index
    }
}
