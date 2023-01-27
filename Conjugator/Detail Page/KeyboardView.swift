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
                    .transition(.offset(x: 0, y: 50).combined(with: .scale(scale: 0.95)).combined(with: .opacity))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
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

    func choiceButton(conversation: Conversation, choice: Choice) -> some View {
        Button {
            levelViewModel.submitChoice(conversation: conversation, choice: choice)
        } label: {
            Text(choice.text)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(16)
        }
        .transition(.scale)
    }
}
