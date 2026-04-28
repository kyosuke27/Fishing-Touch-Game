import SwiftUI

/// カプセル型アクションボタンの共通スタイル。
struct ActionCapsuleButtonStyle: ButtonStyle {
    /// ベースカラー。
    let color: Color

    /// ボタン見た目を生成する。
    /// - Parameter configuration: ボタン状態。
    /// - Returns: スタイル適用済みView。
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(color.opacity(configuration.isPressed ? 0.82 : 1), in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
