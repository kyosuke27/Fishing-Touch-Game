//
//  Theme.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import SwiftUI

enum GameTheme {
    static let mainBlue = Color(red: 58 / 255, green: 145 / 255, blue: 1.0)
    static let subGreen = Color(red: 88 / 255, green: 200 / 255, blue: 176 / 255)
    static let accentYellow = Color(red: 1.0, green: 196 / 255, blue: 79 / 255)
    static let background = Color(red: 241 / 255, green: 248 / 255, blue: 1.0)
    static let card = Color.white
    static let textPrimary = Color(red: 34 / 255, green: 58 / 255, blue: 94 / 255)
    static let textSecondary = Color(red: 109 / 255, green: 128 / 255, blue: 150 / 255)
    static let warning = Color(red: 244 / 255, green: 96 / 255, blue: 96 / 255)
}

struct OceanBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 150 / 255, green: 216 / 255, blue: 1.0),
                GameTheme.background,
                Color(red: 115 / 255, green: 212 / 255, blue: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(alignment: .bottom) {
            WaveShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), GameTheme.mainBlue.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 180)
        }
        .ignoresSafeArea()
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.45))

        for step in stride(from: 0.0, through: rect.width, by: 1) {
            let relative = step / rect.width
            let y = rect.height * 0.45 + sin(relative * .pi * 4) * 14
            path.addLine(to: CGPoint(x: step, y: y))
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(GameTheme.card.opacity(0.9), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
            )
            .shadow(color: GameTheme.mainBlue.opacity(0.16), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}
