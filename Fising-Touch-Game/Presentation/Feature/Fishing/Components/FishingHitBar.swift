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
            let markerWidth = 12.0
            let barX = max(0, min(width - markerWidth, width * state.barPosition))

            ZStack(alignment: .leading) {
                Image("HitBase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .frame(maxHeight: .infinity)

                Image("HitArea")
                    .resizable()
                    .scaledToFit()
                    .frame(height: proxy.size.height)
                    .frame(width: zoneWidth, alignment: .leading)
                    .offset(x: zoneX)
                    .clipped()
                    .overlay {
                        Text(String(localized: "fishing.hit"))
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .frame(width: zoneWidth, height: proxy.size.height)
                            .offset(x: zoneX)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    }

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white)
                    .frame(width: markerWidth, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(GameTheme.mainBlue, lineWidth: 2)
                    )
                    .offset(x: barX)
            }
        }
        .frame(height: 76)
        .padding(.horizontal, 4)
    }
}
