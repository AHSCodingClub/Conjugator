//
//  ConversationView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 1/26/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var levelViewModel: LevelViewModel
    var conversation: Conversation

    var body: some View {
        VStack(spacing: 24) {
            ForEach(conversation.messages) { message in
                MessageView(
                    levelViewModel: levelViewModel,
                    conversation: conversation,
                    message: message
                )
            }
        }
    }
}
