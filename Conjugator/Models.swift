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

enum KeyboardMode {
    case blank
    case info
    case choices(choices: [Choice])
}

/// An enumeration for possible verb forms
enum Form: CaseIterable {
    case yo
    case tu
    case el
    case nosotros
    case vosotros
    case ellos

    static var random: Form {
        return Form.allCases.randomElement() ?? .yo
    }

    var title: String {
        switch self {
        case .yo:
            return "Yo"
        case .tu:
            return "Tú"
        case .el:
            return "Él/Ella/Usted"
        case .nosotros:
            return "Nosotros"
        case .vosotros:
            return "Vosotros"
        case .ellos:
            return "Ellos"
        }
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

    var choices: [Choice] {
        switch verbForms.count {
        case 5:
            let choices = [
                Choice(form: .yo, text: verbForms[0]),
                Choice(form: .tu, text: verbForms[1]),
                Choice(form: .el, text: verbForms[2]),
                Choice(form: .nosotros, text: verbForms[3]),
                Choice(form: .ellos, text: verbForms[4]),
            ]
            return choices
        case 6:
            let choices = [
                Choice(form: .yo, text: verbForms[0]),
                Choice(form: .tu, text: verbForms[1]),
                Choice(form: .el, text: verbForms[2]),
                Choice(form: .nosotros, text: verbForms[3]),
                Choice(form: .vosotros, text: verbForms[4]),
                Choice(form: .ellos, text: verbForms[5]),
            ]
            return choices
        default:
            return [
                Choice(form: .yo, text: "Error on this level. Please let your teacher know.")
            ]
        }
    }
}

struct Conversation: Identifiable {
    let id = UUID()
    var challenge: Challenge
    var correctForm: Form
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
