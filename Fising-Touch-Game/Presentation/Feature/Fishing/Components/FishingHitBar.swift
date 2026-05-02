import SwiftUI

/// 釣り画面のヒット判定バー。
struct FishingHitBar: View {
    /// 現在状態。
    let state: FishingState
    /// 移動バーの横幅。
    private let markerWidth: CGFloat = 12
    /// バー全体の高さ。
    private let barHeight: CGFloat = 76
    /// 移動バーの高さ。
    private let markerHeight: CGFloat = 64

    var body: some View {
        GeometryReader { proxy in
            let barWidth = proxy.size.width
            let topBarWidth = topBarWidth(for: barWidth)
            let topBarX = topBarOffsetX(totalWidth: barWidth, zoneWidth: topBarWidth)
            let markerX = markerOffsetX(totalWidth: barWidth)

            ZStack(alignment: .leading) {
                Image("BaseBar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: barWidth, height: barHeight)

                Image("TopBar")
                    .resizable()
                    .scaledToFill()
                    // 大きさを変更
                    // バーの高さを1/3に変更
                    .frame(width: topBarWidth, height: barHeight / 3)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                    .offset(x: topBarX, y: -4)

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white)
                    .frame(width: markerWidth, height: markerHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(GameTheme.mainBlue, lineWidth: 2)
                    )
                    .offset(x: markerX)
            }
            .frame(width: barWidth, height: barHeight, alignment: .leading)
        }
        .frame(height: barHeight)
        .padding(.horizontal, 4)
    }

    /// TopBarの表示幅を返す。
    /// - Parameter totalWidth: バー全体の横幅。
    /// - Returns: TopBarの表示幅。
    private func topBarWidth(for totalWidth: CGFloat) -> CGFloat {
        totalWidth * state.targetFish.hitZoneWidth
    }

    /// TopBarの表示開始位置を返す。
    /// - Parameters:
    ///   - totalWidth: バー全体の横幅。
    ///   - zoneWidth: TopBarの表示幅。
    /// - Returns: BaseBar内に収まるX座標。
    private func topBarOffsetX(totalWidth: CGFloat, zoneWidth: CGFloat) -> CGFloat {
        let centerX = (totalWidth - 20) * state.hitZoneCenter
        let rawOffsetX = centerX - (zoneWidth / 2)
        return min(max(rawOffsetX, 0), totalWidth - zoneWidth)
    }

    /// 移動バーの表示位置を返す。
    /// - Parameter totalWidth: バー全体の横幅。
    /// - Returns: 移動バーのX座標。
    private func markerOffsetX(totalWidth: CGFloat) -> CGFloat {
        let rawOffsetX = totalWidth * state.barPosition
        return min(max(rawOffsetX, 0), totalWidth - markerWidth)
    }
}

#Preview("Fishing Hit Bar") {
    VStack(spacing: 24) {
        FishingHitBar(
            state: FishingState(
                targetFish: GameMaster.fishes[0],
                currentWeight: 0.2,
                successCount: 0,
                barPosition: 0.25,
                hitZoneCenter: 0.4,
                result: nil,
                isRunning: true
            )
        )

        FishingHitBar(
            state: FishingState(
                targetFish: GameMaster.fishes[2],
                currentWeight: 3.4,
                successCount: 2,
                barPosition: 0.72,
                hitZoneCenter: 0.68,
                result: nil,
                isRunning: true
            )
        )
    }
    .padding()
    .background(GameTheme.background)
}
