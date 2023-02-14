//
//  Course.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

struct Course {
    var name: String?
    var announcementTitle: String?
    var announcement: String?
}

extension Course {
    static func create(from parsingGroup: ParsingGroup) -> Course {
        var course = Course()
        for line in parsingGroup.lines {
            let values = line.values.filter { !$0.isEmpty }
            print("values: \(values)")

            /// key is always the first value
            if let key = values.first {
                switch key.lowercased() {
                case "course_name":

                    /// the course name should be the second value
                    if let value = values[safe: 1] {
                        course.name = value
                    }
                case "announcement_title":
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
