//
//  LevelCardView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

struct LevelCardView: View {
    var level: Level

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(.headline)

                    Text(level.description)
                        .multilineTextAlignment(.leading)

                    Text("Contains \(level.challenges.count) verbs")
                        .font(.caption)
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)

                Image(systemName: "chevron.forward")
                    .foregroundColor(UIColor.secondaryLabel.color)
            }
            .padding(.horizontal, 16)

            let color: Color = {
                if let colorHex = level.colorHex {
                    return Color(hex: colorHex)
                } else {
                    return Color.black
                }
            }()

            color.frame(height: 3)
        }
        .foregroundColor(UIColor.label.color)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(UIColor.systemBackground.color)
        .cornerRadius(16)
    }
}
