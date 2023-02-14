//
//  Choice.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

struct Choice: Identifiable {
    let id = UUID()
    var form: Form
    var text: String /// the conjugated choice
}
