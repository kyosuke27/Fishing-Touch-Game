import SwiftUI

/// 釣り画面のヒット判定バー。
struct FishingHitBar: View {
    /// 現在状態。
    let state: FishingState

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let zoneWidth = width * state.targetFish.hitZoneWidth
            let zoneX = (width * state.hitZoneCenter) - (zoneWidth / 2)
            let barX = max(0, min(width - 12, width * state.barPosition))

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.92), GameTheme.mainBlue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(GameTheme.accentYellow)
                    .frame(width: zoneWidth)
                    .offset(x: zoneX)
                    .overlay {
                        Text(String(localized: "fishing.hit"))
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .frame(width: zoneWidth)
                            .offset(x: zoneX)
                    }

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white)
                    .frame(width: 12, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(GameTheme.mainBlue, lineWidth: 2)
                    )
                    .offset(x: barX)
            }
        }
        .frame(height: 76)
        .padding(12)
        .background(.white.opacity(0.28), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}
