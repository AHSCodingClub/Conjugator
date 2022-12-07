//
//  LevelView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import SwiftUI

struct LevelView: View {
    @ObservedObject var model: ViewModel
    var level: Level
    @StateObject var levelViewModel: LevelViewModel
    
    let lineWidth = CGFloat(5)
    
    init(model: ViewModel, level: Level) {
        self.model = model
        self.level = level
        self._levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                header
                
                ForEach(level.challenges.prefix(levelViewModel.currentLevelIndex + 1), id: \.verb) { challenge in
                    
                    let challenge = level.challenges[levelViewModel.currentLevelIndex]
                    
                    VStack(alignment: .leading) {
                        Text("Verbo:")
                            .font(.headline)
                        
                        Text(challenge.verb)
                            .font(.largeTitle)
                    }
                    .padding(16)
                    .background(UIColor.secondarySystemBackground.color)
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    /// total height = 400
                    VStack(spacing: 20) {
                        ForEach(challenge.forms, id: \.self) { form in
                            Button {
                                withAnimation(.spring()) {
                                    levelViewModel.currentLevelIndex += 1
                                }
                                
                            } label: {
                                Text(form)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .frame(width: 150)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline) /// make the top padding smaller
    }
}

extension LevelView {
    var header: some View {
        VStack(spacing: 10) {
            Image("Profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 60, height: 60)
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors:
                                [
                                    UIColor.secondarySystemBackground.color,
                                    UIColor.secondarySystemBackground.toColor(.systemBackground, percentage: 0.5).color
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: lineWidth
                        )
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                        .padding(-lineWidth / 2)
                }
                
            Text("Conjugator")
                .fontWeight(.medium)
        }
    }
}
