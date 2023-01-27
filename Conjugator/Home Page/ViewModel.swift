//
//  ViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var levels = [Level]()
    @Published var selectedLevel: Level?

    init() {
        self.levels = Level.testingLevels
    }
}
