//
//  ViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var showingDetails = false

    @Published var selectedCourse: Course?
    @Published var selectedLevel: Level?

    @AppStorage("dataSources") @Storage var dataSources = ["1t-onBgRP5BSHZ26XjvmVgi6RxZmpKO7RBI3JARYE3Bs"]
    @Published var selectedDataSource = "1t-onBgRP5BSHZ26XjvmVgi6RxZmpKO7RBI3JARYE3Bs"
    @Published var courses = [Course]()

    func loadLevels() async {
        var courses = [Course]()

        for dataSource in dataSources {
            if let course = await getCourse(from: dataSource) {
                courses.append(course)
            }
        }

        let selectedCourse = courses.first(where: { $0.dataSource == self.selectedDataSource })

        await { @MainActor in
            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                self.courses = courses
                self.selectedCourse = selectedCourse
            }
        }()
    }
}
