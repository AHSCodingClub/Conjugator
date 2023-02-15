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

    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                if let selectedLevel = model.selectedLevel {
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
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Conjugator")
                                    .font(.title.weight(.heavy))

                                if let name = model.course?.name {
                                    Text(name)
                                        .opacity(0.75)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Button {} label: {
                                Image(systemName: "gearshape.fill")
                                    .frame(width: 42, height: 42)
                                    .background {
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                    }
                            }
//                        https://docs.google.com/spreadsheets/d/1t-onBgRP5BSHZ26XjvmVgi6RxZmpKO7RBI3JARYE3Bs/edit#gid=0
                        }

                        if let announcement = model.course?.announcement {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 3) {
                                    if let announcementTitle = model.course?.announcementTitle {
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
                            .padding(.top, 12)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                let color: Color = {
                    if let selectedLevel = model.selectedLevel, let hex = selectedLevel.colorHex {
                        return UIColor(hex: hex).getTextColor(backgroundIsDark: false).color
                    } else {
                        return Color.blue
                    }
                }()

                color

                    .ignoresSafeArea()
            }

            if let selectedLevel = model.selectedLevel {
                LevelView(model: model, level: selectedLevel)
                    .transition(.offset(x: 20).combined(with: .opacity))
            } else {
                VStack {
                    if let levels = model.course?.levels {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
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
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .background(UIColor.secondarySystemBackground.color)
                .transition(.offset(x: -20).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            Task {
                await model.loadLevels()
            }
        }
    }
}
