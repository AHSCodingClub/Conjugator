//
//  Parsing.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import Foundation

func getLevel(fileLines lines: [String]) -> Level {
    var level = Level()

    for index in lines.indices {
        let line = lines[index]

        switch index {
        case 0: level.title = line
        case 1: level.description = line
        case 2:
            if let hex = makeHex(s: line) {
                level.colorHex = hex
            } else if line.count == 6 {
                if let integer = Int(line, radix: 16) {
                    level.colorHex = integer
                }
            } else {
                if let challenge = getChallenge(from: line) {
                    level.challenges.append(challenge)
                }
            }
        default:
            if let challenge = getChallenge(from: line) {
                level.challenges.append(challenge)
            }
        }
    }
    
    return level
}

func makeHex(s: String) -> Int? {
    let s = s.lowercased()

    switch s {
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

/// Sample input:
/// andar: ando, andas, anda, andamos, andáis, andan
func getChallenge(from line: String) -> Challenge? {
    let components = line.components(separatedBy: ":")
    guard components.count == 2 else {
        print(
            "Line must be in the format (verb: form1, form2, form3...). The provided line was: \(line)"
        )
        return nil
    }

    let verb = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
    /// remove whitespace

    var forms = components[1].components(separatedBy: ",")

    for index in forms.indices {
        let form = forms[index].trimmingCharacters(in: .whitespacesAndNewlines)
        /// remove whitespace
        forms[index] = form
    }

    let challenge = Challenge(
        verb: verb,
        forms: forms
    )
    return challenge
}

/// Remember:
/// Line 1 = title
/// Line 2 = description
/// Line 3 = color
/// Every line from then on = words

/// we need to convert this line into the swift struct

func loadSampleLevel() -> [String] {
    if let filePath = Bundle.main.path(forResource: "SampleLevel", ofType: "txt") {
        do {
            let contents = try String(contentsOfFile: filePath)
            return contents.components(separatedBy: "\n")
        } catch {
            print("Couldn't find file: \(error)")
        }
    }

    return []
}
