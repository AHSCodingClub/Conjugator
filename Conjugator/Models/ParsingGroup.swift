//
//  Parsing.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

struct ParsingGroup {
    var kind: Kind
    var lines = [Line]()

    enum Kind: String {
        case general
        case level
    }
}

struct Line {
    var values: [String]
}
