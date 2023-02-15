//
//  Course.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

struct Course {
    var dataSource: String
    var name: String?
    var announcementTitle: String?
    var announcement: String?
    var levels = [Level]()
}

extension Course {
    static func create(dataSource: String, parsingGroup: ParsingGroup) -> Course {
        var course = Course(dataSource: dataSource)
        for line in parsingGroup.lines {
            let values = line.values.filter { !$0.isEmpty }

            /// key is always the first value
            if let key = values.first {
                let key = String(key.filter { $0 != "_" })
                switch key.lowercased() {
                case "coursename":

                    /// the course name should be the second value
                    if let value = values[safe: 1] {
                        course.name = value
                    }
                case "announcementtitle":
                    if let value = values[safe: 1] {
                        course.announcementTitle = value
                    }
                case "announcement":
                    if let value = values[safe: 1] {
                        course.announcement = value
                    }
                default:
                    break
                }
            }
        }

        return course
    }
}
