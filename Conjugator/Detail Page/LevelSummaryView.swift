//
//  LevelSummaryView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 3/13/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import SwiftUI

struct LevelSummaryView: View {
    @ObservedObject var levelViewModel: LevelViewModel
    
    var body: some View {
        let timeElapsed: String = {
            if let finalTimeElapsed = levelViewModel.finalTimeElapsed {
                return String(format: "%.2f", finalTimeElapsed)
            }
            return ""
        }()
        
        let numberIncorrect = levelViewModel.conversations.flatMap { $0.strikethroughChoices }.count
        
        VStack(spacing: 10) {
            LevelSummaryRow(title: levelViewModel.level.timeMode.title, description: "\(timeElapsed)s Elapsed")
            LevelSummaryRow(title: "# Lives", description: levelViewModel.level.livesMode.title)
            LevelSummaryRow(title: "# Incorrect", description: numberIncorrect == 0 ? "Perfect Score" : "\(numberIncorrect)")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            UIColor.label.color
                .opacity(0.03)
        )
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(UIColor.secondaryLabel.color, lineWidth: 1)
        }
    }
}

struct LevelSummaryRow: View {
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .fontWeight(.semibold)
        }
        .foregroundColor(UIColor.secondaryLabel.color)
    }
}
