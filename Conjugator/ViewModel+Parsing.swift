//
//  ViewModel+Parsing.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

extension ViewModel {
    func getCourse(parsingGroups: [ParsingGroup]) async -> Course {
        var course = Course()

        for parsingGroup in parsingGroups {
            switch parsingGroup.kind {
            case .course:
                course = Course.create(from: parsingGroup)
            case .level:
                let level = Level.create(from: parsingGroup)
                course.levels.append(level)
            }
        }

        return course
    }
}
