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
    @StateObject var levelViewModel: LevelViewModel
    
    let lineWidth = CGFloat(5)
    
    init(model: ViewModel, level: Level) {
        self.model = model
        self._levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                header
                
                messages
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline) /// make the top padding smaller
    }
}

extension LevelView {
    @ViewBuilder var messages: some View {
        MessagesTypingIndicator()
            .padding()
            .background(Color.black)
        
        ForEach(levelViewModel.interactions) { interaction in
            VStack {
                if interaction.step == .typingQuestion {}
            }
            
//            let challenge = level.challenges[levelViewModel.currentLevelIndex]
//
//            VStack(alignment: .leading) {
//                Text("Verbo:")
//                    .font(.headline)
//
//                Text(challenge.verb)
//                    .font(.largeTitle)
//            }
//            .padding(16)
//            .background(UIColor.secondarySystemBackground.color)
//            .cornerRadius(16)
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            /// total height = 400
//            VStack(spacing: 20) {
//                ForEach(challenge.forms, id: \.self) { form in
//                    Button {
//                        withAnimation(.spring()) {
//                            levelViewModel.currentLevelIndex += 1
//                        }
//
//                    } label: {
//                        Text(form)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color.blue)
//                            .cornerRadius(16)
//                    }
//                }
//            }
//            .frame(width: 150)
//            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

extension LevelView {
    var header: some View {
        VStack(spacing: 12) {
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

struct MessagesTypingIndicator: View {
    @State var highlightedIndex = 0
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    static let numberOfDots = 3

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< MessagesTypingIndicator.numberOfDots) { index in
                Circle()
                    .fill(.white)
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
