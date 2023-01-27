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

struct LineShape: Shape {
    var horizontal: Bool
    func path(in rect: CGRect) -> Path {
        return Path { path in
            if horizontal {
                path.move(
                    to: .init(
                        x: rect.minX,
                        y: rect.midY
                    )
                )
                path.addLine(
                    to: .init(
                        x: rect.maxX,
                        y: rect.midY
                    )
                )
            } else {
                path.move(
                    to: .init(
                        x: rect.midX,
                        y: rect.minY
                    )
                )
                path.addLine(
                    to: .init(
                        x: rect.midX,
                        y: rect.maxY
                    )
                )
            }
        }
    }
}

/// A vertical stack that adds separators
/// From https://movingparts.io/variadic-views-in-swiftui
struct DividedVStack<Content: View>: View {
    var spacing: CGFloat
    var leadingMargin: CGFloat
    var trailingMargin: CGFloat
    var color: UIColor?
    var content: Content

    public init(
        spacing: CGFloat = 0,
        leadingMargin: CGFloat = 0,
        trailingMargin: CGFloat = 0,
        color: UIColor? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.leadingMargin = leadingMargin
        self.trailingMargin = trailingMargin
        self.color = color
        self.content = content()
    }

    public var body: some View {
        _VariadicView.Tree(
            DividedVStackLayout(
                spacing: spacing,
                leadingMargin: leadingMargin,
                trailingMargin: trailingMargin,
                color: color
            )
        ) {
            content
        }
    }
}

struct DividedVStackLayout: _VariadicView_UnaryViewRoot {
    var spacing: CGFloat
    var leadingMargin: CGFloat
    var trailingMargin: CGFloat
    var color: UIColor?

    @ViewBuilder
    public func body(children: _VariadicView.Children) -> some View {
        let last = children.last?.id

        VStack(spacing: spacing) {
            ForEach(children) { child in
                child

                if child.id != last {
                    Divider()
                        .opacity(color == nil ? 1 : 0)
                        .overlay(
                            color.map { Color($0) } ?? .clear /// If we drop iOS 14 support, we can use `.overlay {}` and add an `if-else` statement here.
                        )
                        .padding(.leading, leadingMargin)
                        .padding(.trailing, trailingMargin)
                }
            }
        }
    }
}
