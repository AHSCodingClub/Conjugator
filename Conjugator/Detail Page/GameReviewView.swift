//
//  GameReviewView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 3/13/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct GameReviewView: View {
    @ObservedObject var levelViewModel: LevelViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if levelViewModel.outcome == .failed {
                    Text("Better Luck Next Time!")
                        .font(.title3.weight(.medium))
                } else {
                    Text("Completo!")
                        .font(.title3.weight(.medium))
                }

                button
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(20)
        }
    }

    var button: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                levelViewModel.showingLevelReview.toggle()
            }
        } label: {
            HStack {
                if levelViewModel.outcome == .failed {
                    Text("Game Over")
                } else {
                    Text("Level Review")
                }

                Spacer()

                Image(systemName: "chevron.forward")
                    .rotationEffect(.degrees(levelViewModel.showingLevelReview ? 90 : 0))
            }
            .foregroundColor(.white)
            .font(.title.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background {
                let colors: [Color] = {
                    if levelViewModel.outcome == .failed {
                        return [.red, .pink]
                    } else {
                        return [.blue, .green]
                    }
                }()

                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .cornerRadius(12)
            .shadow(color: .blue.opacity(0.25), radius: 12, x: 0, y: 4)
        }
    }
}
