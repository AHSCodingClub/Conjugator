//
//  ViewModel+Parsing.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

extension ViewModel {
    func parse(parsingGroups: [ParsingGroup]) async {
        var course = Course()
        var levels = [Level]()

        for parsingGroup in parsingGroups {
            switch parsingGroup.kind {
            case .course:
                course = Course.create(from: parsingGroup)
            case .level:
                let level = Level.create(from: parsingGroup)
                levels.append(level)
            }
        }

        await { @MainActor in
            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                self.course = course
                self.levels = levels
            }
        }()
    }
}
