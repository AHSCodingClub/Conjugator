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
                    VStack(alignment: .leading) {
                        if let header {
                            Text(header)
                                .font(.headline)
                        }

                        Text(title)
                            .font(.largeTitle)

                        if let footer {
                            Text(footer)
                                .font(.caption)
                        }
                    }
                    .transition(.scale)
                }
            }
            .padding(16)
            .background(UIColor.secondarySystemBackground.color)
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .leading)

        case let .choices(choices):
            VStack(spacing: 20) {
                ForEach(choices) { choice in

                    Button {
                        levelViewModel.submitChoice(conversation: conversation, form: choice.form)
                    } label: {
                        Text(choice.text)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
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
