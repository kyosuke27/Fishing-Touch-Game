import SwiftUI

/// 非活性のラベル風ボタンを表示する共通View。
struct BadgeButton: View {
    /// 表示テキスト。
    let title: String
    /// 背景色。
    let color: Color

    var body: some View {
        Text(title)
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(color, in: Capsule())
    }
}
