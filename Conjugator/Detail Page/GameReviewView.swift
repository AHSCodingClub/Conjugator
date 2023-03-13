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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if levelViewModel.outcome == .failed {
                    Text("Better Luck Next Time!")
                        .font(.title3.weight(.medium))
                } else {
                    Text("Completo!")
                        .font(.title3.weight(.medium))
                }

                VStack(spacing: 12) {
                    button

                    if levelViewModel.showingLevelReview {
                        review
                    }
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
            HStack(alignment: .top) {
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
                if levelViewModel.outcome == .failed {
                    Text("Game Over")
                } else {
                    Text("Level Review")
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
                    if levelViewModel.outcome == .failed {
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
