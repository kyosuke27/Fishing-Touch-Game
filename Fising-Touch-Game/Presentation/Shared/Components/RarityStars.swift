import SwiftUI

/// レアリティを星で表示する共通View。
struct RarityStars: View {
    /// 星の数。
    let rarity: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<rarity, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundStyle(GameTheme.accentYellow)
            }
        }
    }
}
