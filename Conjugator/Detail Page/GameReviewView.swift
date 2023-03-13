//
//  GameReviewView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 3/13/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct GameReviewView: View {
    @ObservedObject var levelViewModel: LevelViewModel

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        let largeWidth = horizontalSizeClass == .regular || verticalSizeClass == .compact
        let layout = largeWidth
            ? AnyLayout(HStackLayout(alignment: .top, spacing: 12))
            : AnyLayout(VStackLayout(alignment: .leading, spacing: 8))

        ScrollView {
            layout {
                VStack(alignment: .leading, spacing: 8) {
                    VStack {
                        switch levelViewModel.outcome {
                        case .finishedSuccessfully:
                            Text("Completo!")
                        case .failed(let failureReason):
                            switch failureReason {
                            case .outOfTime:
                                Text("You Lost on Time :(")
                            case .tooManyMistakes:
                                Text("Better Luck Next Time")
                            }
                        case .inProgress:
                            Text("Error, game shouldn't still be in progress")
                        }
                    }
                    .font(.title3.weight(.medium))

                    button

                    if levelViewModel.showingLevelReview {
                        LevelSummaryView(levelViewModel: levelViewModel)
                    }
                }

                if levelViewModel.showingLevelReview {
                    review
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(20)
        }
    }

    var review: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(levelViewModel.conversations) { conversation in

                conversationView(conversation: conversation)
            }
        }
    }

    @ViewBuilder func conversationView(conversation: Conversation) -> some View {
        let containsIncorrect = !conversation.strikethroughChoices.isEmpty

        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: containsIncorrect ? .top : .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.challenge.verb)
                        .font(.title3)

                    Text(conversation.correctForm.title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if containsIncorrect {
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(conversation.strikethroughChoices) { incorrectChoice in
                            Text(incorrectChoice.text)
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    Text(conversation.correctChoice.text)
                        .foregroundColor(.green)
                        .brightness(-0.1)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)

            if containsIncorrect {
                Divider()
                    .padding(.leading, 16)

                HStack {
                    Text("Correct Answer:")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(conversation.correctChoice.text)
                        .foregroundColor(.green)
                        .brightness(-0.1)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        }
        .background(UIColor.systemBackground.color)
        .cornerRadius(12)
    }

    var button: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                levelViewModel.showingLevelReview.toggle()
            }
        } label: {
            HStack {
                if case .failed = levelViewModel.outcome {
                    Text("Game Over")
                } else {
                    let timeElapsed: String = {
                        if let finalTimeElapsed = levelViewModel.finalTimeElapsed {
                            return String(format: "%.2f", finalTimeElapsed)
                        }
                        return ""
                    }()

                    Text("Finished in \(timeElapsed)s!")
                }

                Spacer()

                Image(systemName: "chevron.forward")
                    .rotationEffect(.degrees(levelViewModel.showingLevelReview ? 90 : 0))
            }
            .foregroundColor(.white)
            .font(.title.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background {
                let colors: [Color] = {
                    if case .failed = levelViewModel.outcome {
                        return [.red, .pink]
                    } else {
                        return [.blue, .green]
                    }
                }()

                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .cornerRadius(12)
            .shadow(color: .blue.opacity(0.25), radius: 12, x: 0, y: 4)
        }
    }
}
