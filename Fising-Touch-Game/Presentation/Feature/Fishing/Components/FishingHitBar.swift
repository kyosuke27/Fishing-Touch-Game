import SwiftUI

/// 釣り画面のヒット判定バー。
struct FishingHitBar: View {
    /// 現在状態。
    let state: FishingState
    /// BaseBarの丸み分を除いた左右余白。
    private let horizontalInset: CGFloat = 10
    /// 移動バーの横幅。
    private let markerWidth: CGFloat = 12
    /// バー全体の高さ。
    private let barHeight: CGFloat = 76
    /// 移動バーの高さ。
    private let markerHeight: CGFloat = 64

    var body: some View {
        GeometryReader { proxy in
            let barWidth = proxy.size.width
            // 実際に利用できる範囲
            let playableWidth = max(barWidth - (horizontalInset * 2), 0)
            let topBarWidth = topBarWidth(for: playableWidth)
            let topBarX = topBarOffsetX(playableWidth: playableWidth, zoneWidth: topBarWidth)
            let markerX = markerOffsetX(playableWidth: playableWidth)

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
                    .offset(x: topBarX + horizontalInset, y: -4)

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white)
                    .frame(width: markerWidth, height: markerHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(GameTheme.mainBlue, lineWidth: 2)
                    )
                    .offset(x: markerX + horizontalInset)
            }
            .frame(width: barWidth, height: barHeight, alignment: .leading)
        }
        .frame(height: barHeight)
        .padding(.horizontal, 4)
    }

    /// TopBarの表示幅を返す。
    /// - Parameter playableWidth: 有効なバー横幅。
    /// - Returns: TopBarの表示幅。
    private func topBarWidth(for playableWidth: CGFloat) -> CGFloat {
        // hitZoneWidth:0~1の表示割合部分
        // プレイヤーが使用できる領域（baseBarの端の部分を除いた部分）にバー全体の割合をかける
        playableWidth * state.targetFish.hitZoneWidth
    }

    /// TopBarの表示開始位置を返す。
    /// - Parameters:
    ///   - playableWidth: 有効なバー横幅。
    ///   - zoneWidth: TopBarの表示幅。
    /// - Returns: BaseBar内に収まるX座標。
    private func topBarOffsetX(playableWidth: CGFloat, zoneWidth: CGFloat) -> CGFloat {
        let centerX = playableWidth * state.hitZoneCenter
        let rawOffsetX = centerX - (zoneWidth / 2)
        return min(max(rawOffsetX, 0), playableWidth - zoneWidth)
    }

    /// 移動バーの表示位置を返す。
    /// - Parameter playableWidth: 有効なバー横幅。
    /// - Returns: 移動バーのX座標。
    private func markerOffsetX(playableWidth: CGFloat) -> CGFloat {
        let rawOffsetX = playableWidth * state.barPosition
        return min(max(rawOffsetX, 0), playableWidth - markerWidth)
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
