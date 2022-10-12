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
    
    init(model: ViewModel, level: Level) {
        self.model = model
        self.level = level
        self._levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    var body: some View {
        VStack {
            let challenge = level.challenges[levelViewModel.currentLevelIndex]
            
            Text(challenge.verb)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
            
            VStack {
                ForEach(challenge.forms, id: \.self) { form in
                    Text(form)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
