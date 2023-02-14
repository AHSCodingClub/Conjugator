//
//  Message.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    var content: Content

    enum Content {
        case prompt(typing: Bool, header: String?, title: String, footer: String?)
        case response(choice: Choice, correct: Bool?)
    }
}
