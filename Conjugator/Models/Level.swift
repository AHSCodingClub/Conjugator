//
//  Level.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

struct Level {
    var title: String = ""
    var description: String = ""
    var colorHex: Int? = nil
    var randomizationMode = RandomizationMode.randomForm
    var livesMode = LivesMode.fixed(3)

    /// There should be at least two challenges
    var challenges: [Challenge] = []

    enum RandomizationMode {
        case randomForm
        case setForm(Form)
    }

    enum LivesMode {
        case unlimited
        case fixed(Int)
        case suddenDeath
    }
}

struct GameSummary {
    var accuracy: CGFloat
    var answers: [Answer]

    struct Answer: Identifiable {
        let id = UUID()
    }
}

enum KeyboardMode {
    case blank
    case info
    case conversation(conversation: Conversation)
    case finished
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
