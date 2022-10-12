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
    var challenges: [Challenge] = []
}

struct Challenge {
    var verb: String = ""

    /**
     Should be of length 6 and contain forms for: **yo, tú, el, nosotros, vosotros, ellos**
     */
    var forms: [String] = []
}

extension Level {
    static let testingLevels: [Level] = [
        Level(
            title: "Nivel Fácil (presente)",
            description: "Algunos verbos fáciles en tiempo presente",
            colorHex: 0x00AEEF,
            challenges: [
                Challenge(verb: "comer", forms: ["como", "comes", "come", "comemos", "coméis", "comen"]),
                Challenge(verb: "beber", forms: ["bebo", "bebes", "bebe", "bebemos", "bebéis", "beben"]),
                Challenge(verb: "andar", forms: ["ando", "andas", "anda", "andamos", "andáis", "andan"]),
            ]
        ),
        Level(
            title: "Go-go verbs (presente)",
            description: "Más dificiles",
            colorHex: 0x009900,
            challenges: [
                Challenge(verb: "tener", forms: ["tengo", "tienes", "tiene", "tenemos", "tenéis", "tienen"]),
                Challenge(verb: "poner", forms: ["pongo", "pones", "pone", "ponemos", "ponéis", "ponen"]),
            ]
        ),
        Level(
            title: "Nivel Fácil (preterito)",
            description: "Un poco difícil",
            colorHex: nil,
            challenges: [
                Challenge(verb: "beber", forms: ["bebí", "bebiste", "bebió", "bebimos", "bebisteis", "bebieron"]),
                Challenge(verb: "ir", forms: ["fui", "fuiste", "fue", "fuimos", "fuisteis", "fueron"]),
            ]
        ),
    ]
}
