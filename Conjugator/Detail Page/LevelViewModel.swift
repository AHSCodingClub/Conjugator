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
    @Published var finished = false
    @Published var keyboardMode = KeyboardMode.blank
    @Published var conversations = [Conversation]()

    init(level: Level) {
        self.level = level
    }
}

extension LevelViewModel {
    func start() {
        withAnimation {
            self.keyboardMode = .info
        }

        loadNextChallenge()
    }

    func loadNextChallenge() {
        let displayedChallenges = conversations.map { $0.challenge }

        if let challenge = level.challenges.first(where: { !displayedChallenges.contains($0) }) {
            var conversation: Conversation = {
                switch level.mode {
                case .randomForm:
                    return Conversation(challenge: challenge, correctForm: .random, choices: challenge.getChoices())
                case .setForm(let form):
                    return Conversation(challenge: challenge, correctForm: form, choices: challenge.getChoices())
                }
            }()

            let message = Message(content: .prompt(typing: true, header: "Verbo:", title: challenge.verb, footer: conversation.correctForm.title))
            conversation.messages.append(message)

            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                conversations.append(conversation)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                guard
                    let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }),
                    let messageIndex = self.conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
                else { return }

                withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    self.conversations[conversationIndex].messages[messageIndex].content = .prompt(typing: false, header: "Verbo:", title: challenge.verb, footer: conversation.correctForm.title)
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }) else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                    self.keyboardMode = .conversation(conversation: self.conversations[conversationIndex])
                }
            }

        } else {
            /// no more challenges!

            withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                finished = true
                keyboardMode = .finished
            }
        }
    }

    func submitChoice(conversation: Conversation, choice: Choice) {
        guard
            let conversationIndex = conversations.firstIndex(where: { $0.id == conversation.id })
        else { return }

        withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
            conversations[conversationIndex].selectedChoice = choice
            keyboardMode = .conversation(conversation: conversations[conversationIndex])
        }

        let message = Message(content: .response(choice: choice, correct: nil))
        withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
            self.conversations[conversationIndex].messages.append(message)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard
                let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }),
                let messageIndex = self.conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
            else { return }

            let correct = self.conversations[conversationIndex].correctForm == choice.form

            withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                if !correct {
                    self.conversations[conversationIndex].selectedChoice = nil
                    self.conversations[conversationIndex].strikethroughChoices.append(choice)
                }

                self.conversations[conversationIndex].messages[messageIndex].content = .response(choice: choice, correct: correct)
                self.keyboardMode = .conversation(conversation: self.conversations[conversationIndex])
            }

            if correct {
                self.loadNextChallenge()
            } else {
                if true {
                    let message = Message(content: .prompt(typing: false, header: nil, title: "¡Incorrecto!", footer: nil))
                    withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                        self.conversations[conversationIndex].messages.append(message)
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        guard
                            let conversationIndex = self.conversations.firstIndex(where: { $0.id == conversation.id }),
                            let messageIndex = self.conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id })
                        else { return }

                        withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                            self.conversations[conversationIndex].messages[messageIndex].content = .prompt(typing: false, header: nil, title: "¡Incorrecto!", footer: "Otra vez?")
                        }
                    }
                }
            }
        }
    }
}
