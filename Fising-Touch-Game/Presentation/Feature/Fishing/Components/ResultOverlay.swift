import SwiftUI

/// 釣り結果を表示するオーバーレイ。
struct ResultOverlay: View {
    /// 表示対象の結果。
    let result: FishingResult
    /// 再挑戦アクション。
    let onRetry: () -> Void
    /// 閉じるアクション。
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                switch result {
                case let .success(catchRecord, isNewRecord, isNewFish):
                    FishBadge(fish: GameMaster.fish(id: catchRecord.fishId) ?? GameMaster.fishes[0], size: 110)
                    VStack(spacing: 8) {
                        Text(String(localized: "fishing.result.success"))
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.textPrimary)
                        Text(catchRecord.fishName)
                            .font(.title.bold())
                            .foregroundStyle(GameTheme.mainBlue)
                        RarityStars(rarity: catchRecord.rarity)
                    }

                    VStack(spacing: 10) {
                        DetailRow(title: String(localized: "fishing.result.weight"), value: catchRecord.weight.formattedWeight)
                        DetailRow(title: String(localized: "fishing.result.reward"), value: "\(catchRecord.rewardCoin)")
                        DetailRow(
                            title: String(localized: "fishing.result.encyclopedia"),
                            value: isNewFish ? String(localized: "fishing.result.new") : String(localized: "fishing.result.registered")
                        )
                        if isNewRecord {
                            DetailRow(title: String(localized: "fishing.result.record"), value: String(localized: "fishing.result.best"))
                        }
                    }

                case let .failure(target):
                    FishBadge(fish: target, size: 110)
                    VStack(spacing: 8) {
                        Text(String(localized: "fishing.result.failure"))
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.warning)
                        Text(target.name)
                            .font(.title2.bold())
                            .foregroundStyle(GameTheme.textPrimary)
                    }
                }

                VStack(spacing: 12) {
                    Button(String(localized: "fishing.result.retry"), action: onRetry)
                        .buttonStyle(ActionCapsuleButtonStyle(color: GameTheme.mainBlue))
                    Button(String(localized: "fishing.result.close"), action: onClose)
                        .buttonStyle(ActionCapsuleButtonStyle(color: GameTheme.subGreen))
                }
            }
            .frame(maxWidth: 340)
            .glassCard()
            .padding(20)
        }
    }
}
