import SwiftUI

/// ホームメニューで使う共通ボタン。
struct HomeMenuButton: View {
    /// 表示テキスト。
    let title: String
    /// 表示アイコン。
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2.bold())
            Text(title)
                .font(.headline.bold())
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            LinearGradient(colors: [GameTheme.subGreen, Color.green.opacity(0.85)], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.85), lineWidth: 2)
        )
    }
}
