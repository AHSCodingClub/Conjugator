//
//  MessageView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 1/26/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var levelViewModel: LevelViewModel
    var conversation: Conversation
    var message: Message

    var body: some View {
        switch message.content {
        case let .prompt(typing, header, title, footer):

            VStack {
                if typing {
                    MessagesTypingIndicator()
                        .foregroundColor(UIColor.secondaryLabel.color)
                        .transition(.scale)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        if let header {
                            Text(header)
                                .font(.caption)
                        }

                        Text(title)
                            .font(.largeTitle)

                        if let footer {
                            Text(footer)
                                .font(.headline)
                                .padding(.top, 10)
                        }
                    }
                    .transition(.scale)
                }
            }
            .padding(16)
            .background(UIColor.secondarySystemBackground.color)
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .leading)

        case .choices, .response:

            let (choices, correct): ([Choice], Bool?) = {
                switch message.content {
                case let .choices(choices):
                    return (choices, nil)
                case let .response(choice, correct):
                    return ([choice], correct)
                default:
                    return ([], nil)
                }
            }()

            VStack(spacing: 20) {
                ForEach(choices) { choice in

                    Button {
                        levelViewModel.submitChoice(conversation: conversation, message: message, choice: choice)
                    } label: {
                        Text(choice.text)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .overlay(alignment: .topLeading) {
                        if let correct {
                            Circle()
                                .fill(UIColor.secondarySystemBackground.color)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: correct ? "checkmark" : "xmark")
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundColor(correct ? .green : .red)
                                }
                                .transition(.scale)
                                .offset(x: -20, y: -20)
                        }
                    }
                    .transition(.scale(scale: 0.2).combined(with: .opacity))
                }
            }
            .frame(width: 150)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .transition(.scale(scale: 0.9, anchor: .trailing).combined(with: .opacity))
        case let .response(choice, correct):
            Text("asd")
        }
    }
}
