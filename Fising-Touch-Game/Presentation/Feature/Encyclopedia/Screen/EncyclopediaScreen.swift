import SwiftUI

/// 魚図鑑画面。
struct EncyclopediaScreen: View {
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore

    /// グリッド定義。
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    /// Screenを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
    }

    var body: some View {
        ZStack {
            OceanBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "encyclopedia.title"))
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.textPrimary)
                        Text("\(String(localized: "encyclopedia.progress")) \(store.unlockedFishCount) / \(GameMaster.fishes.count)")
                            .font(.headline)
                            .foregroundStyle(GameTheme.textSecondary)
                    }
                    .glassCard()

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(GameMaster.fishes) { fish in
                            if let entry = store.encyclopediaEntry(for: fish.id), entry.isUnlocked {
                                NavigationLink {
                                    FishDetailScreen(fish: fish, entry: entry)
                                } label: {
                                    EncyclopediaCard(fish: fish, entry: entry)
                                }
                                .buttonStyle(.plain)
                            } else {
                                LockedFishCard()
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}

/// 魚詳細画面。
private struct FishDetailScreen: View {
    /// 表示対象の魚。
    let fish: FishMaster
    /// 表示対象の図鑑エントリ。
    let entry: EncyclopediaEntry

    var body: some View {
        ZStack {
            OceanBackground()

            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 12) {
                        FishBadge(fish: fish, size: 120)
                        Text(fish.name)
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.textPrimary)
                        RarityStars(rarity: fish.rarity)
                    }
                    .glassCard()

                    VStack(alignment: .leading, spacing: 12) {
                        Label(String(localized: "encyclopedia.description"), systemImage: "text.alignleft")
                            .font(.headline)
                            .foregroundStyle(GameTheme.textPrimary)
                        Text(fish.description)
                            .foregroundStyle(GameTheme.textSecondary)
                        Divider()
                        DetailRow(title: String(localized: "encyclopedia.maxWeight"), value: entry.maxWeight?.formattedWeight ?? "-")
                        DetailRow(title: String(localized: "encyclopedia.requiredHits"), value: "\(fish.requiredHits)")
                    }
                    .glassCard()
                }
                .padding(20)
            }
        }
        .navigationTitle(String(localized: "encyclopedia.detailTitle"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 図鑑用カード。
private struct EncyclopediaCard: View {
    /// 表示対象の魚。
    let fish: FishMaster
    /// 表示対象の図鑑エントリ。
    let entry: EncyclopediaEntry

    var body: some View {
        VStack(spacing: 12) {
            FishBadge(fish: fish, size: 88)
            Text(fish.name)
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textPrimary)
            RarityStars(rarity: fish.rarity)
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }
}

/// 未解放魚カード。
private struct LockedFishCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.75))
                .frame(width: 88, height: 88)
                .overlay(
                    Image(systemName: "questionmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(GameTheme.textSecondary)
                )
            Text(String(localized: "encyclopedia.lockedTitle"))
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textSecondary)
            Text(String(localized: "encyclopedia.lockedSubtitle"))
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }
}
