//
//  LevelConfigurationView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 3/13/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import SwiftUI

struct LevelConfigurationView: View {
    @ObservedObject var levelViewModel: LevelViewModel
    
    var body: some View {
        let timeElapsed: String = {
            if let finalTimeElapsed = levelViewModel.finalTimeElapsed {
                return String(format: "%.2f", finalTimeElapsed)
            }
            return ""
        }()
        
        VStack {
            HStack {
                Text(levelViewModel.level.timeMode.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(timeElapsed)s Elapsed")
            }
            
            HStack {
                Text("Randomization Mode")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                Text("\(timeElapsed)s Elapsed")
            }
        }
        .foregroundColor(UIColor.secondaryLabel.color)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            UIColor.label.color
                .opacity(0.03)
        )
        .cornerRadius(12)
    }
}
