//
//  Views.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 1/26/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct MessagesTypingIndicator: View {
    @State var highlightedIndex = 0
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    static let numberOfDots = 3

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< MessagesTypingIndicator.numberOfDots) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .opacity(index == highlightedIndex ? 1 : 0.5)
                    .scaleEffect(index == highlightedIndex ? 1.2 : 1)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.5)) {
                if highlightedIndex < MessagesTypingIndicator.numberOfDots - 1 {
                    highlightedIndex += 1
                } else {
                    highlightedIndex = 0
                }
            }
        }
    }
}
