//
//  Conversation.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

struct Conversation: Identifiable {
    let id = UUID()
    var challenge: Challenge
    var correctForm: Form
    var showingChoices = false
    var choices: [Choice]
    var selectedChoice: Choice?
    var strikethroughChoices = [Choice]()
    var status = Status.questionAsked
    var messages = [Message]()

    /// compare text, not choice.
    var correctText: String {
        if let choice = choices.first(where: { $0.form == correctForm }) {
            return choice.text
        } else {
            print("Error getting correct text")
            return ""
        }
    }

    var correctChoice: Choice {
        if let choice = choices.first(where: { $0.form == correctForm }) {
            return choice
        } else {
            print("Error getting choice")
            return .init(form: .yo, text: "Error")
        }
    }

    enum Status: Equatable {
        case questionAsked
        case questionAnsweredCorrectly
    }
}
