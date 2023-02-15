//
//  AllCoursesView.swift
//  Conjugator
//
//  Created by Zheng on 2/14/23.
//

import SwiftUI

struct RowView: View {
    var title: String
    var image: String
    var imageShown: Bool
    var backgroundShown: Bool
    var backgroundColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: image)
                    .opacity(imageShown ? 1 : 0)
            }
            .padding(.horizontal, backgroundShown ? 16 : 0)
            .padding(.vertical, backgroundShown ? 12 : 0)
            .background(
                backgroundColor
                    .cornerRadius(16)
                    .opacity(backgroundShown ? 1 : 0)
            )
        }
        .opacity(backgroundShown ? 1 : 0.75)
        .transition(.scale(scale: 0.9).combined(with: .opacity))
    }
}

struct AllCoursesView: View {
    @ObservedObject var model: ViewModel
    @State var showingAddCourseView = false

    let courseColumns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    LazyVGrid(columns: courseColumns, spacing: 6) {
                        ForEach(model.courses, id: \.dataSource) { course in

                            if model.showingDetails || model.selectedDataSource == course.dataSource {
                                let name = course.name ?? "Untitled Course"

                                RowView(
                                    title: name,
                                    image: "checkmark",
                                    imageShown: model.selectedDataSource == course.dataSource,
                                    backgroundShown: true,
                                    backgroundColor: UIColor.secondarySystemBackground.color
                                ) {
                                    model.selectedCourse = course
                                    model.selectedDataSource = course.dataSource
                                }
                            }
                        }

                        RowView(
                            title: "Add Course",
                            image: "plus",
                            imageShown: true,
                            backgroundShown: true,
                            backgroundColor: UIColor.secondarySystemBackground.color
                        ) {
                            withAnimation {
                                showingAddCourseView.toggle()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .navigationTitle("All Courses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarCloseButton()
        }
        .sheet(isPresented: $showingAddCourseView) {
            AddCourseView(model: model)
        }
//        .alert(
//            "Error Adding Course",
//            isPresented: Binding {
//                error != nil
//            } set: { _ in
//                error = nil
//            }
//        ) {
//            Button("OK") {}
//        } message: {
//            if let error {
//                Text("Error: \(error). Please contact your teacher.")
//            } else {
//                Text("Unknown Error. Please contact your teacher.")
//            }
//        }
    }
}
