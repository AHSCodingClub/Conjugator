//
//  ContentView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModel()
    @State var showingAddCourseView = false

    let levelColumns = [
        GridItem(.adaptive(minimum: 200))
    ]

    let courseColumns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                if let selectedLevel = model.selectedLevel {
                    levelHeader(selectedLevel: selectedLevel)
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: model.showingDetails ? 12 : 2) {
                            Text("Conjugator")
                                .font(.title.weight(.heavy))

                            VStack(alignment: .leading, spacing: 8) {
                                if model.showingDetails {
                                    Button {
                                        model.showingAllCoursesView = true
                                    } label: {
                                        HStack(spacing: 5) {
                                            Text("My Courses")

                                            Image(systemName: "chevron.right")
                                        }
                                        .fontWeight(.bold)
                                    }
                                }

                                courses
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        announcement
                    }
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                                model.showingDetails.toggle()
                            }
                        } label: {
                            ZStack {
                                Image(systemName: "xmark")
                                    .opacity(model.showingDetails ? 1 : 0)

                                Image(systemName: "ellipsis")
                                    .opacity(model.showingDetails ? 0 : 1)
                            }
                            .rotationEffect(.degrees(model.showingDetails ? 90 : 0))
                            .frame(width: 42, height: 42)
                            .background {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            }
                        }
                        .padding(.top, -6) /// shift the button up a bit
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .background {
                let color: Color = {
                    if let selectedLevel = model.selectedLevel, let hex = selectedLevel.colorHex {
                        return UIColor(hex: hex).getTextColor(backgroundIsDark: false).color
                    } else {
                        return Color.blue
                    }
                }()

                color
                    .brightness(-0.2)
                    .ignoresSafeArea()
            }

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $showingAddCourseView) {
            AddCourseView(model: model)
        }
        .sheet(isPresented: $model.showingAllCoursesView) {
            AllCoursesView(model: model)
        }
        .onAppear {
            Task {
                await model.loadLevels()
            }
        }
    }
}

extension ContentView {
    @ViewBuilder var courses: some View {
        LazyVGrid(columns: courseColumns, spacing: 6) {
            ForEach(model.courses.prefix(model.maximumCoursesToDisplay), id: \.dataSource) { course in

                if model.showingDetails || model.selectedDataSource == course.dataSource {
                    let name = course.name ?? "Untitled Course"

                    RowView(
                        title: name,
                        image: "checkmark",
                        imageShown: model.showingDetails && (model.selectedDataSource == course.dataSource),
                        backgroundShown: model.showingDetails,
                        backgroundColor: .white.opacity(0.1)
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                            model.selectedCourse = course
                            model.selectedDataSource = course.dataSource
                        }
                    }
                }
            }

            if model.showingDetails {
                RowView(
                    title: "Add Course",
                    image: "plus",
                    imageShown: true,
                    backgroundShown: true,
                    backgroundColor: .white.opacity(0.1)
                ) {
                    showingAddCourseView = true
                }
            }
        }
        .disabled(!model.showingDetails) /// prevent tapping the course when not in detail mode

        if model.showingDetails {
            /// If there are courses that aren't shown, show how many are left.
            if model.courses.count > model.maximumCoursesToDisplay {
                let numberOfCoursesLeft = model.courses.count - model.maximumCoursesToDisplay

                Button {
                    model.showingAllCoursesView = true
                } label: {
                    HStack(spacing: 6) {
                        if numberOfCoursesLeft == 1 {
                            Text("\(numberOfCoursesLeft) more course")
                        } else {
                            Text("\(numberOfCoursesLeft) more courses")
                        }

                        Image(systemName: "chevron.forward")
                    }
                    .font(.caption)
                }
            }
        }
    }

    @ViewBuilder var announcement: some View {
        if !model.showingDetails, let announcement = model.selectedCourse?.announcement {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    if let announcementTitle = model.selectedCourse?.announcementTitle {
                        Text(announcementTitle)
                            .textCase(.uppercase)
                            .font(.caption)
                    }

                    Text(announcement)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Image(systemName: "person.wave.2.fill")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .transition(.scale(scale: 0.8, anchor: .bottom).combined(with: .opacity))
        }
    }
}

extension ContentView {
    func levelHeader(selectedLevel: Level) -> some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                    model.selectedLevel = nil
                }
            } label: {
                Image(systemName: "chevron.backward")

                    .fontWeight(.medium)
                    .padding(.trailing, 16)
                    .padding(.vertical, 16)
                    .contentShape(Rectangle())
                    .font(.title3)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .overlay {
            Text(selectedLevel.title)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
    }

    @ViewBuilder var content: some View {
        if let selectedLevel = model.selectedLevel {
            LevelView(model: model, level: selectedLevel)
                .transition(.offset(x: 20).combined(with: .opacity))
        } else {
            VStack {
                if let levels = model.selectedCourse?.levels {
                    ScrollView {
                        LazyVGrid(columns: levelColumns, spacing: 16) {
                            ForEach(levels, id: \.title) { level in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                                        model.selectedLevel = level
                                    }
                                } label: {
                                    LevelCardView(level: level)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        Task {
                            await model.loadLevels()
                        }
                    }
                } else if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("No Courses")
                        .foregroundColor(UIColor.secondaryLabel.color)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(UIColor.secondarySystemBackground.color)
            .transition(.offset(x: -20).combined(with: .opacity))
        }
    }
}
