//
//  KeyboardView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 1/26/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var levelViewModel: LevelViewModel

    var body: some View {
        switch levelViewModel.keyboardMode {
        case .blank:
            EmptyView()
        case .info:
            VStack(spacing: 16) {
                Text(levelViewModel.level.title)
                    .font(.headline.bold())

                Text(levelViewModel.level.description)
            }
        case .conversation(conversation: let conversation):
            VStack(alignment: .leading) {
                Text("Seleccione una opción.")
                    .font(.headline.bold())

                conversationView(conversation: conversation)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .id(conversation.id)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))

                VStack(alignment: .leading, spacing: 14) {
                    progressView(conversation: conversation)

                    timeView(conversation: conversation)
                }
                .animation( /// fade in and out the time elapsed / time remaining string
                    .spring(response: 0.3, dampingFraction: 1, blendDuration: 1),
                    value: levelViewModel.timeString == nil
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        case .finished:
            GameReviewView(levelViewModel: levelViewModel)
        }
    }

    @ViewBuilder func progressView(conversation: Conversation) -> some View {
        let totalCount = levelViewModel.level.challenges.count

        let startedCount: Int = {
            let startedCount = levelViewModel.conversations.filter { $0.showingChoices }.count
            return startedCount
        }()

        let completeCount: Int = {
            let completeCount = levelViewModel.conversations.filter { $0.status == .questionAnsweredCorrectly }.count
            return completeCount
        }()

        let startedPercent = CGFloat(startedCount) / CGFloat(totalCount)
        let completePercent = CGFloat(completeCount) / CGFloat(totalCount)

        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Pregunta **\(startedCount)/\(totalCount)**")

                Spacer()

                switch levelViewModel.level.livesMode {
                case .unlimited:
                    EmptyView()
                case .suddenDeath:
                    Text("Sudden Death")
                        .foregroundColor(.white)
                        .font(.caption)
                        .textCase(.uppercase)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(6)
                case .fixed(let fixed):
                    let livesLeft = fixed - levelViewModel.incorrectChoicesCount

                    HStack(spacing: 4) {
                        ForEach(0 ..< fixed) { index in
                            let active = index < livesLeft
                            LiveHeartView(active: active)
                        }
                    }
                }
            }
            .foregroundColor(.blue)

            progressBar(color: .blue, topProgress: completePercent, bottomProgress: startedPercent)
        }
    }

    @ViewBuilder func timeView(conversation: Conversation) -> some View {
        switch levelViewModel.level.timeMode {
        case .none:
            EmptyView()
        case .stopwatch:
            VStack(alignment: .leading, spacing: 8) {
                let timeString = levelViewModel.timeString ?? ""

                HStack {
                    Text("Time Elapsed: \(timeString)")

                    Spacer()
                }
                .foregroundColor(.green)
                .brightness(-0.1)
            }
            .opacity(levelViewModel.timeString == nil ? 0 : 1)
        case .timer(let seconds):

            VStack(alignment: .leading, spacing: 8) {
                let timeString = levelViewModel.timeString ?? ""
                let timeElapsed = levelViewModel.timeElapsed ?? 0

                HStack {
                    Text("Time Remaining: \(timeString)")

                    Spacer()
                }
                .foregroundColor(.purple)

                let progress = timeElapsed / Double(seconds)

                progressBar(color: .purple, topProgress: progress, bottomProgress: 0)
                    .animation(.spring(), value: progress)
            }
            .opacity(levelViewModel.timeString == nil ? 0 : 1)
        }
    }

    func progressBar(color: Color, topProgress: Double, bottomProgress: Double) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .opacity(0.1)

                if let bottomProgress {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .opacity(0.3)
                        .frame(width: bottomProgress * geometry.size.width)
                }

                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: topProgress * geometry.size.width)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 4)
    }

    @ViewBuilder func conversationView(conversation: Conversation) -> some View {
        switch conversation.choices.count {
        case 5:
            HStack {
                VStack {
                    choiceButton(conversation: conversation, choice: conversation.choices[0])
                    choiceButton(conversation: conversation, choice: conversation.choices[1])
                    choiceButton(conversation: conversation, choice: conversation.choices[2])
                }
                VStack {
                    choiceButton(conversation: conversation, choice: conversation.choices[4])
                    Spacer()
                    choiceButton(conversation: conversation, choice: conversation.choices[5])
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        case 6:
            HStack {
                VStack {
                    choiceButton(conversation: conversation, choice: conversation.choices[0])
                    choiceButton(conversation: conversation, choice: conversation.choices[1])
                    choiceButton(conversation: conversation, choice: conversation.choices[2])
                }
                VStack {
                    choiceButton(conversation: conversation, choice: conversation.choices[3])
                    choiceButton(conversation: conversation, choice: conversation.choices[4])
                    choiceButton(conversation: conversation, choice: conversation.choices[5])
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        default:
            Text("Number of choices is invalid")
        }
    }

    @ViewBuilder func choiceButton(conversation: Conversation, choice: Choice) -> some View {
        let (opacity, brightness): (CGFloat, CGFloat) = {
            if let selectedChoice = conversation.selectedChoice {
                if selectedChoice.id == choice.id {
                    return (1, 0)
                } else {
                    return (0.9, -0.2)
                }

            } else {
                return (1, 0)
            }
        }()

        let strikethrough = conversation.strikethroughChoices.contains(where: { $0.id == choice.id })

        Button {
            levelViewModel.submitChoice(conversation: conversation, choice: choice)
        } label: {
            Text(choice.text)
                .foregroundColor(.white)
                .overlay {
                    LineShape(horizontal: true)
                        .trim(from: 0, to: strikethrough ? 1 : 0)
                        .stroke(UIColor.red.toColor(.white, percentage: 0.25).color, lineWidth: 3)
                        .opacity(strikethrough ? 1 : 0)
                        .frame(height: 3)
                        .padding(.horizontal, -10)
                        .offset(y: 2) /// lower the strikethrough a bit
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color.blue
                        .brightness(strikethrough ? -0.2 : 0)
                )
                .cornerRadius(16)
        }
        .opacity(opacity)
        .brightness(brightness)
        .disabled(strikethrough)
    }
}

struct LiveHeartView: View {
    var active: Bool

    var body: some View {
        ZStack {
            Image(systemName: "heart.fill")
                .foregroundColor(UIColor.secondarySystemFill.color)

            Image(systemName: "heart.fill")
                .foregroundColor(UIColor.red.color)
                .opacity(active ? 1 : 0)
        }
    }
}
