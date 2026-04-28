import SwiftUI

/// 画面全体で利用する配色定義。
enum GameTheme {
    /// メインカラー。
    static let mainBlue = Color(red: 58 / 255, green: 145 / 255, blue: 1.0)
    /// サブカラー。
    static let subGreen = Color(red: 88 / 255, green: 200 / 255, blue: 176 / 255)
    /// アクセントカラー。
    static let accentYellow = Color(red: 1.0, green: 196 / 255, blue: 79 / 255)
    /// 背景色。
    static let background = Color(red: 241 / 255, green: 248 / 255, blue: 1.0)
    /// カード背景色。
    static let card = Color.white
    /// 主テキスト色。
    static let textPrimary = Color(red: 34 / 255, green: 58 / 255, blue: 94 / 255)
    /// 補助テキスト色。
    static let textSecondary = Color(red: 109 / 255, green: 128 / 255, blue: 150 / 255)
    /// 警告色。
    static let warning = Color(red: 244 / 255, green: 96 / 255, blue: 96 / 255)
}

/// 海をイメージした共通背景。
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

/// 波形を描画するShape。
struct WaveShape: Shape {
    /// 波形のPathを返す。
    /// - Parameter rect: 描画範囲。
    /// - Returns: 生成したPath。
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.45))

        for step in stride(from: 0.0, through: rect.width, by: 1) {
            let relativePosition = step / rect.width
            let yPosition = rect.height * 0.45 + sin(relativePosition * .pi * 4) * 14
            path.addLine(to: CGPoint(x: step, y: yPosition))
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

/// ガラス調カード見た目を提供するModifier。
struct GlassCardModifier: ViewModifier {
    /// 見た目を適用する。
    /// - Parameter content: 対象View。
    /// - Returns: 装飾済みView。
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

/// 共通装飾のショートカット。
extension View {
    /// ガラス調カードを適用する。
    /// - Returns: 装飾済みView。
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}
