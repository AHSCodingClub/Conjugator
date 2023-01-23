//
//  Level.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct Level {
    var title: String = ""
    var description: String = ""
    var colorHex: Int? = nil
    /// There should be at least two challenges
    var challenges: [Challenge] = []
}

struct Challenge: Hashable {
    var verb: String = ""

    /**
     Should be of length 6 and contain forms for **yo, tú, él/ella/usted, nosotros/nosotras, vosotros/vosotras, and ellos/ellas/ustedes**
     */
    var verbForms: [String] = []
}

struct Conversation: Identifiable, Hashable, Equatable {
    let id = UUID()
    var challenge: Challenge
    var step = Step.typingQuestion

    enum Step {
        case typingQuestion
        case sentQuestion
        case choicesDisplayed
        case choicesAnswered
        case answerConfirmed
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) /// just check the id for equality
    }

    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.id == rhs.id
    }

//    struct Step: OptionSet {
//        let rawValue: Int
//
//        static let typingQuestion = Step(rawValue: 1 << 0) /// 1
//        static let sentQuestion = Step(rawValue: 1 << 1) /// 2
//        static let choicesDisplayed = Step(rawValue: 1 << 2) /// 4
//        static let choicesAnswered = Step(rawValue: 1 << 3) /// 8
//        static let answerConfirmed = Step(rawValue: 1 << 4) /// 16
//    }
}

extension Level {
    static let testingLevels: [Level] = [
        Level(
            title: "Nivel Fácil (presente)",
            description: "Algunos verbos fáciles en tiempo presente",
            colorHex: 0x00AEEF,
            challenges: [
                Challenge(
                    verb: "comer",
                    verbForms: ["como", "comes", "come", "comemos", "coméis", "comen"]),
                Challenge(
                    verb: "beber",
                    verbForms: ["bebo", "bebes", "bebe", "bebemos", "bebéis", "beben"]),
                Challenge(
                    verb: "andar",
                    verbForms: ["ando", "andas", "anda", "andamos", "andáis", "andan"]),
            ]),
        Level(
            title: "Go-go verbs (presente)",
            description: "Más dificiles",
            colorHex: 0x009900,
            challenges: [
                Challenge(
                    verb: "tener",
                    verbForms: ["tengo", "tienes", "tiene", "tenemos", "tenéis", "tienen"]),
                Challenge(
                    verb: "poner", verbForms: ["pongo", "pones", "pone", "ponemos", "ponéis", "ponen"]),
            ]),
        Level(
            title: "Nivel Fácil (preterito)",
            description: "Un poco difícil",
            colorHex: nil,
            challenges: [
                Challenge(
                    verb: "tener",
                    verbForms: ["tengo", "tienes", "tiene", "tenemos", "tenéis", "tienen"]),
                Challenge(
                    verb: "poner",
                    verbForms: ["pongo", "pones", "pone", "ponemos", "ponéis", "ponen"]),
            ]),
    ]
}
