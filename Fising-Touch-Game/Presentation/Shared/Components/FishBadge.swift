import SwiftUI

/// 魚アイコンを丸バッジで表現する共通View。
struct FishBadge: View {
    /// 表示対象の魚。
    let fish: FishMaster
    /// バッジサイズ。
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, rarityColor.opacity(0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)

            Image(systemName: fish.assetName)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(rarityColor)
        }
        .shadow(color: rarityColor.opacity(0.22), radius: 12, x: 0, y: 8)
    }

    /// レアリティに応じた色を返す。
    private var rarityColor: Color {
        switch fish.rarity {
        case 3:
            GameTheme.accentYellow
        case 2:
            GameTheme.subGreen
        default:
            GameTheme.mainBlue
        }
    }
}
