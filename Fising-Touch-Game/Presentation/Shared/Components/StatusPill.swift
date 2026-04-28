import SwiftUI

/// 上部ステータス表示用のカプセルView。
struct StatusPill: View {
    /// 表示するタイトル。
    let title: String
    /// 表示するSF Symbols名。
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(GameTheme.accentYellow)
            Text(title)
                .font(.headline.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            LinearGradient(colors: [GameTheme.mainBlue, Color.blue.opacity(0.85)], startPoint: .top, endPoint: .bottom),
            in: Capsule()
        )
    }
}
