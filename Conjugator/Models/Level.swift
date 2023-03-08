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
    var timeMode = TimeMode.stopwatch
    var randomizationMode = RandomizationMode.randomForm
    var livesMode = LivesMode.fixed(3)

    /// There should be at least two challenges
    var challenges: [Challenge] = []

    enum TimeMode {
        case none
        case stopwatch
        case timer(Int) /// stores the time limit
    }

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

extension Level {
    static func create(from parsingGroup: ParsingGroup) -> Level {
        var level = Level()
        for line in parsingGroup.lines {
            let values = line.values.filter { !$0.isEmpty }

            /// key is always the first value
            if let key = values.first {
                switch key.lowercased() {
                case "title":

                    /// the level title should be the second value
                    if let value = values[safe: 1] {
                        level.title = value
                    }
                case "description":
                    if let value = values[safe: 1] {
                        level.description = value
                    }
                case "color":
                    if let value = values[safe: 1] {
                        if let hex = makeHexColor(from: value) {
                            level.colorHex = hex
                        } else if value.count == 6 {
                            if let integer = Int(value, radix: 16) {
                                level.colorHex = integer
                            }
                        }
                    }
                case "randomization_mode":
                    break
                case "lives_mode":
                    break
                case "word":
                    if let verb = values[safe: 1] {
                        let verbForms = Array(values.dropFirst(2)) /// remove the "Word" label and the first value (which is the verb)

                        let challenge = Challenge(
                            verb: verb,
                            verbForms: verbForms)
                        level.challenges.append(challenge)
                    }

                default:
                    break
                }
            }
        }

        return level
    }

    static func makeHexColor(from readableString: String) -> Int? {
        switch readableString {
        case "red": return 0xFF0000
        case "orange": return 0xFFA500
        case "yellow": return 0xFFFF00
        case "green": return 0x00FF00
        case "blue": return 0x0000FF
        case "purple": return 0xA020F0
        case "black": return 0x000000
        case "white": return 0xFFFFFF
        default: return nil
        }
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
            description: "Más difícil",
            colorHex: 0x009900,
            challenges: [
                Challenge(
                    verb: "tener",
                    verbForms: ["tengo", "tienes", "tiene", "tenemos", "tenéis", "tienen"]),
                Challenge(
                    verb: "poner",
                    verbForms: ["pongo", "pones", "pone", "ponemos", "ponéis", "ponen"]),
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
