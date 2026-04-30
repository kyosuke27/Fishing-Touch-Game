import SwiftUI

/// ホーム画面専用のステータスカード。
struct StatusCard: View {
    /// ラベル名。
    let title: String
    /// 表示値。
    let value: String
    /// 表示画像名。
    let imageName: String

    var body: some View {
        HStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)
                Text(value)
                    .font(.headline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                    .lineLimit(1)
        }
        .padding(.horizontal,8)
        .padding(.vertical,2)
        .background(.black.opacity(0.25), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: GameTheme.mainBlue.opacity(0.12), radius: 12, x: 0, y: 8)
    }
}
