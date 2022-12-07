//
//  LevelViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class LevelViewModel: ObservableObject {
    var level: Level

    @Published var interactions = [ChallengeInteraction]()

    init(level: Level) {
        self.level = level
    }
}
