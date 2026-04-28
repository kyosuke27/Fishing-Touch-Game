import SwiftUI

/// 釣果一覧画面。
struct CatchHistoryScreen: View {
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore

    /// Screenを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
    }

    var body: some View {
        ZStack {
            OceanBackground()

            if store.userData.catchHistory.isEmpty {
                ContentUnavailableView(
                    String(localized: "history.empty.title"),
                    systemImage: "fish",
                    description: Text(String(localized: "history.empty.description"))
                )
            } else {
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(store.userData.catchHistory) { record in
                            CatchHistoryCard(catchRecord: record, fish: store.fishMaster(for: record.fishId))
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle(String(localized: "history.title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 釣果カード。
private struct CatchHistoryCard: View {
    /// 表示対象の釣果。
    let catchRecord: CaughtFish
    /// 対応する魚マスタ。
    let fish: FishMaster?

    var body: some View {
        HStack(spacing: 14) {
            FishBadge(fish: fish ?? GameMaster.fishes[0], size: 64)
            VStack(alignment: .leading, spacing: 6) {
                Text(catchRecord.fishName)
                    .font(.headline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                Text("\(catchRecord.weight.formattedWeight) / \(String(localized: "history.reward")) \(catchRecord.rewardCoin)")
                    .foregroundStyle(GameTheme.textSecondary)
                Text(catchRecord.caughtAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(GameTheme.textSecondary)
            }
            Spacer()
            RarityStars(rarity: catchRecord.rarity)
        }
        .glassCard()
    }
}
