import SwiftUI

/// 魚図鑑画面。
struct EncyclopediaScreen: View {
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore
    /// ロックカード表示確認用の一時ダミー件数。
    private let temporaryLockedCardCount = 2

    /// 画面左右の余白。
    private let horizontalPadding: CGFloat = 18
    /// カード間の横余白。
    private let gridSpacing: CGFloat = 14

    /// Screenを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
    }

    var body: some View {
        GeometryReader { geometry in
            let columns = [
                GridItem(.flexible(), spacing: gridSpacing),
                GridItem(.flexible(), spacing: gridSpacing)
            ]

            ZStack {
                encyclopediaBackground(
                    size: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets
                )

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text(String(localized: "encyclopedia.title"))
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundStyle(GameTheme.textPrimary)
                                .multilineTextAlignment(.center)
                            Text("\(String(localized: "encyclopedia.progress")) \(store.unlockedFishCount) / \(GameMaster.fishes.count)")
                                .font(.headline)
                                .foregroundStyle(GameTheme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, horizontalPadding)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(GameMaster.fishes) { fish in
                                if let entry = store.encyclopediaEntry(for: fish.id), entry.isUnlocked {
                                    NavigationLink {
                                        FishDetailScreen(fish: fish, entry: entry)
                                    } label: {
                                        EncyclopediaCard(fish: fish, entry: entry)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    HiddenLockedFishCard()
                                }
                            }

                            ForEach(0..<temporaryLockedCardCount, id: \.self) { _ in
                                HiddenLockedFishCard()
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }

    /// 図鑑一覧背景を返す。
    /// - Parameter size: 画面サイズ。
    /// - Parameter safeAreaInsets: セーフエリア余白。
    /// - Returns: 背景View。
    private func encyclopediaBackground(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
        Image("ListBackground")
            .resizable()
            .scaledToFill()
            .frame(
                width: size.width,
                height: size.height + safeAreaInsets.top + safeAreaInsets.bottom,
                alignment: .center
            )
            .clipped()
            .ignoresSafeArea()
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.10),
                        Color.white.opacity(0.18),
                        GameTheme.background.opacity(0.48)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
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
        VStack(spacing: 4) {
            FishBadge(fish: fish, size: 88)
            Text(fish.name)
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textPrimary)
            RarityStars(rarity: fish.rarity)
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 176)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.84), lineWidth: 1.5)
        )
        .shadow(color: GameTheme.mainBlue.opacity(0.12), radius: 16, x: 0, y: 10)
    }
}

/// 未解放魚カード。
private struct LockedFishCard: View {
    var body: some View {
        VStack(spacing: 4) {
            FishBadge(fish: GameMaster.fishes[0], size: 88, isHidden: true)
            Text(String(localized: "encyclopedia.lockedTitle"))
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textSecondary)
            Text(String(localized: "encyclopedia.lockedSubtitle"))
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 176)
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.78), lineWidth: 1.5)
        )
        .shadow(color: GameTheme.mainBlue.opacity(0.10), radius: 16, x: 0, y: 10)
    }
}

/// マスタ未登録魚用のロックカード。
private struct HiddenLockedFishCard: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                FishBadge(fish: GameMaster.fishes[0], size: 88, isHidden: true)

                Image("Blok")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .offset(x: 22, y: 22)
            }

            Text(String(localized: "encyclopedia.lockedTitle"))
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textSecondary)

            Text(String(localized: "encyclopedia.lockedSubtitle"))
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 176)
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.78), lineWidth: 1.5)
        )
        .shadow(color: GameTheme.mainBlue.opacity(0.10), radius: 16, x: 0, y: 10)
    }
}
