//
//  ViewModel+DeleteCourse.swift
//  Conjugator
//
//  Created by Zheng on 2/14/23.
//

import SwiftUI

extension ViewModel {
    func deleteCourse(course: Course) {
        withAnimation {
            if let index = courses.firstIndex(where: { $0.dataSource == course.dataSource }) {
                courses.remove(at: index)
            }
            
            if let index = dataSources.firstIndex(where: { $0 == course.dataSource }) {
                dataSources.remove(at: index)
            }
            
            if let course = courses.first, let dataSource = dataSources.first {
                selectedCourse = course
                selectedDataSource = dataSource
            } else {
                selectedCourse = nil
                selectedDataSource = ""
                showingDetails = true
            }
        }
        
    }
}
