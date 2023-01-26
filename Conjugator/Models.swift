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
    var mode = Mode.randomForm

    /// There should be at least two challenges
    var challenges: [Challenge] = []
}

enum Mode {
    case randomForm
    case setForm(Form)
}

/// An enumeration for possible verb forms
enum Form: Int, CaseIterable {
    case yo = 0
    case tu = 1
    case el = 2
    case nosotros = 3
    case vosotros = 4
    case ellos = 5

    static var random: Form {
        return Form.allCases.randomElement() ?? .yo
    }
}

struct Choice: Identifiable {
    let id = UUID()
    var form: Form
    var text: String /// the conjugated choice
}

struct Challenge: Hashable {
    var verb: String = ""

    /**
     Should be of length 6 and contain forms for **yo, tú, él/ella/usted, nosotros/nosotras, vosotros/vosotras, and ellos/ellas/ustedes**
     */
    var verbForms: [String] = []
}

struct Conversation: Identifiable {
    let id = UUID()
    var challenge: Challenge
    var form: Form
    var status = Status.questionAsked
    var messages = [Message]()

    enum Status: Equatable {
        case questionAsked
        case questionAnsweredCorrectly(numberOfAttempts: Int)
        case questionAnsweredIncorrectly
    }
}

struct Message: Identifiable {
    let id = UUID()
    var content: Content

    enum Content {
        case prompt(typing: Bool, header: String?, title: String, footer: String?)
        case choices(choices: [Choice])
        case response(choice: Choice, correct: Bool?)
    }
}

//
// extension Conversation: Hashable, Equatable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id) /// just check the id for equality
//    }
//
//    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
//        return lhs.id == rhs.id
//    }
// }
//
// extension Message: Hashable, Equatable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id) /// just check the id for equality
//    }
//
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.id == rhs.id
//    }
// }

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
