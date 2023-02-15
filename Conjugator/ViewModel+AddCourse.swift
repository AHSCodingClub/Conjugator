//
//  ViewModel+AddCourse.swift
//  Conjugator
//
//  Created by Zheng on 2/14/23.
//

import SwiftUI

extension ViewModel {
    func addCourse(inputString: String, error: Binding<String?>) async {
//    https://docs.google.com/spreadsheets/d/1t-onBgRP5BSHZ26XjvmVgi6RxZmpKO7RBI3JARYE3Bs/edit#gid=0

        let components = inputString.components(separatedBy: "/")
        if let dIndex = components.firstIndex(of: "d") {
            let idIndex = dIndex + 1

            if let id = components[safe: idIndex] {
                await self.addCourse(dataSource: id, error: error)
                return
            }
        }

        /// try just entering the string
        await self.addCourse(dataSource: inputString, error: error)
    }

    func addCourse(dataSource: String, error: Binding<String?>) async {
        if let course = await getCourse(from: dataSource) {
            if self.courses.contains(where: { $0.dataSource == course.dataSource }) {
                error.wrappedValue = "You already have this course (\(course.name ?? "Untitled Course"))"
            } else {
                self.courses.append(course)
                self.dataSources.append(dataSource)
                self.selectedCourse = course
                self.selectedDataSource = dataSource
                self.showingAddCourseView = false
            }
        } else {
            error.wrappedValue = "The input URL was invalid"
        }
    }
}
