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
    @StateObject var levelViewModel: LevelViewModel

    let lineWidth = CGFloat(5)
    let headerLength = CGFloat(80)

    init(model: ViewModel, level: Level) {
        self.model = model
        self._levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    header

                    ForEach(levelViewModel.conversations) { conversation in
                        ConversationView(levelViewModel: levelViewModel, conversation: conversation)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .rotationEffect(.degrees(180))
                .scaleEffect(x: -1.0, y: 1.0)
            }
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1.0, y: 1.0)

            Divider()
            
            Color.clear
                .frame(height: 300)
                .background {
                    UIColor.secondarySystemBackground.color
                        .ignoresSafeArea()
                }
                .overlay {
                    KeyboardView(levelViewModel: levelViewModel)
                }
        }
        .navigationBarTitleDisplayMode(.inline) /// make the top padding smaller
        .onAppear {
            levelViewModel.start()
        }
    }
}

extension LevelView {
//    VStack {
//        switch conversation.step {
//        case .typingQuestion:
//            MessagesTypingIndicator()
//                .foregroundColor(UIColor.secondaryLabel.color)
//                .transition(.scale)
//        default:
//            VStack(alignment: .leading) {
//                Text("Verbo:")
//                    .font(.headline)
//
//                Text(conversation.challenge.verb)
//                    .font(.largeTitle)
//            }
//            .transition(.scale)
//        }
//    }
//    .padding(16)
//    .background(UIColor.secondarySystemBackground.color)
//    .cornerRadius(16)
//    .frame(maxWidth: .infinity, alignment: .leading)

//    if conversation.step == .choicesDisplayed || conversation.step == .choicesAnswered {
//        choice(conversation: conversation)
//    }
}

extension LevelView {
    var header: some View {
        VStack(spacing: 12) {
            Image("Profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: headerLength, height: headerLength)
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors:
                                [
                                    UIColor.secondarySystemBackground.color,
                                    UIColor.secondarySystemBackground.toColor(.systemBackground, percentage: 0.5).color
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: lineWidth
                        )
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                        .padding(-lineWidth / 2)
                }

            Text("Conjugator")
                .fontWeight(.medium)
        }
    }
}
