//
//  LevelViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import Combine
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
        loadNextChallenge()
    }

    func loadNextChallenge() {
        let displayedChallenges = conversations.map { $0.challenge }

        if let challenge = level.challenges.first(where: { !displayedChallenges.contains($0) }) {
            var conversation: Conversation = {
                switch level.mode {
                case .randomForm:
                    return Conversation(challenge: challenge, correctForm: .random)
                case .setForm(let form):
                    return Conversation(challenge: challenge, correctForm: form)
                }
            }()

            let message = Message(content: .prompt(typing: true, header: "Verbo:", title: challenge.verb, footer: conversation.correctForm.title))
            conversation.messages.append(message)

            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                conversations.append(conversation)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard
                    let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }),
                    let messageIndex = self.conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
                else { return }

                withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    self.conversations[conversationIndex].messages[messageIndex].content = .prompt(typing: false, header: "Verbo:", title: challenge.verb, footer: conversation.correctForm.title)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }) else { return }

                withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                    let message = Message(content: .choices(choices: challenge.choices))
                    self.conversations[conversationIndex].messages.append(message)
                }
            }

        } else {
            /// no more challenges!

            print("Done!")
            withAnimation {
                finished = true
            }
        }
    }

    func submitChoice(conversation: Conversation, message: Message, choice: Choice) {
        guard
            let conversationIndex = conversations.firstIndex(where: { $0.id == conversation.id }),
            let messageIndex = conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
        else { return }

        withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
            self.conversations[conversationIndex].messages[messageIndex].content = .response(choice: choice, correct: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard
                let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }),
                let messageIndex = self.conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
            else { return }

            let correct = conversation.correctForm == choice.form

            withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                self.conversations[conversationIndex].messages[messageIndex].content = .response(choice: choice, correct: correct)
            }

            if correct {
                self.loadNextChallenge()
            } else {
                if true {
                    let message = Message(content: .prompt(typing: false, header: nil, title: "¡Incorrecto!", footer: nil))
                    withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                        self.conversations[conversationIndex].messages.append(message)
                    }
                }
            }
        }
    }
}
