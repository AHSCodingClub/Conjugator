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

    let courseColumns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                LazyVGrid(columns: courseColumns, spacing: 6) {
                    ForEach(model.courses, id: \.dataSource) { course in

                        let name = course.name ?? "Untitled Course"

                        Button {
                            model.selectedCourse = course
                            model.selectedDataSource = course.dataSource
                        } label: {
                            HStack {
                                Text(name)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if model.selectedDataSource == course.dataSource {
                                    Image(systemName: "checkmark")
                                        .opacity(model.showingDetails ? 1 : 0)
                                }
                            }
                            .opacity(model.showingDetails ? 1 : 0.75)
                            .padding(.horizontal, model.showingDetails ? 16 : 0)
                            .padding(.vertical, model.showingDetails ? 12 : 0)
                            .background(
                                Color.white
                                    .opacity(0.1)
                                    .cornerRadius(16)
                                    .opacity(model.showingDetails ? 1 : 0)
                            )
                        }
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }

                    if model.showingDetails {
                        Button {
                            model.showingAddCourseView = true
                        } label: {
                            HStack {
                                Text("Add Course")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Image(systemName: "plus")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                Color.white
                                    .opacity(0.1)
                                    .cornerRadius(16)
                            )
                        }
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationTitle("All Courses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarCloseButton()
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
