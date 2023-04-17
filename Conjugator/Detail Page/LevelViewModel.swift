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
    @Published var outcome = Outcome.inProgress
    @Published var keyboardMode = KeyboardMode.blank

    @Published var conversations = [Conversation]()
    @Published var incorrectChoicesCount = 0
    @Published var showingLevelReview = false

    @Published var timeString: String?

    var startDate: Date?
    var timer: Timer?
    var timeElapsed: Double? {
        if let startDate {
            return Date().timeIntervalSince(startDate)
        } else {
            return nil
        }
    }

    var finalTimeElapsed: Double?

    init(level: Level) {
        self.level = level
    }

    enum Outcome {
        case inProgress
        case finishedSuccessfully
        case failed(FailureReason)

        enum FailureReason {
            case outOfTime
            case tooManyMistakes
        }
    }
}

extension LevelViewModel {
    func start() {
        withAnimation {
            self.keyboardMode = .info
        }

        loadNextChallenge()

        switch level.timeMode {
        case .none:
            break
        case .stopwatch:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.startDate = Date()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    guard let self else { return }

                    /// Make sure the game hasn't finished
                    guard case .inProgress = self.outcome else { return }

                    let timeElapsed = self.timeElapsed ?? 0
                    self.timeString = "\(String(format: "%.2f", timeElapsed))s"
                }
            }
        case .timer(let seconds):

            /// start timer a little later
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.startDate = Date()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    guard let self else { return }

                    /// Make sure the game hasn't finished
                    guard case .inProgress = self.outcome else { return }

                    let timeElapsed = self.timeElapsed ?? 0

                    if timeElapsed > Double(seconds) {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.finish(outcome: .failed(.outOfTime))
                    } else {
                        let remaining = Double(seconds) - timeElapsed
                        self.timeString = "\(String(format: "%.2f", remaining))s"
                    }
                }
            }
        }
    }

    func loadNextChallenge() {
        let displayedChallenges = conversations.map { $0.challenge }

        if let challenge = level.challenges.first(where: { !displayedChallenges.contains($0) }) {
            let correctForm = Form.random(includeVosotros: challenge.verbForms.count == 6)

            let choices: [Choice] = {
                switch level.gridMode {
                case .randomGrid:
                    return challenge.getChoices().shuffled()
                case .fixedGrid:
                    return challenge.getChoices()
                }
            }()

            var conversation = Conversation(challenge: challenge, correctForm: correctForm, choices: choices)

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
                    self.conversations[conversationIndex].showingChoices = true
                    self.keyboardMode = .conversation(conversation: self.conversations[conversationIndex])
                }
            }

        } else {
            /// no more challenges!

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.finish(outcome: .finishedSuccessfully)
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
                self.conversations[conversationIndex].messages[messageIndex].content = .response(choice: choice, correct: correct)

                if correct {
                    self.conversations[conversationIndex].status = .questionAnsweredCorrectly
                } else {
                    self.incorrectChoicesCount += 1

                    switch self.level.livesMode {
                    case .unlimited:
                        break
                    case .suddenDeath:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.finish(outcome: .failed(.tooManyMistakes))
                        }
                    case .fixed(let fixed):
                        if self.incorrectChoicesCount >= fixed {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                self.finish(outcome: .failed(.tooManyMistakes))
                            }
                        }
                    }

                    self.conversations[conversationIndex].selectedChoice = nil
                    self.conversations[conversationIndex].strikethroughChoices.append(choice)
                }

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

    func finish(outcome: Outcome) {
        finalTimeElapsed = timeElapsed

        withAnimation(.spring(response: 0.8, dampingFraction: 1, blendDuration: 1)) {
            self.outcome = outcome
        }
        withAnimation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 1)) {
            self.keyboardMode = .finished
        }
    }
}
