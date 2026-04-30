import SwiftUI

/// 釣り画面上部で使うステータスカード。
struct FishingStatusCard: View {
    /// ラベル名。
    let title: String
    /// 表示値。
    let value: String
    /// 表示画像名。
    let imageName: String

    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(GameTheme.textSecondary)
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.9), lineWidth: 1.5)
        )
    }
}
