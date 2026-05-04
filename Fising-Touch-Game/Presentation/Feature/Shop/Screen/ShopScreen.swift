import SwiftUI

/// ショップ画面。
struct ShopScreen: View {
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore

    /// Screenを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                shopBackground(
                    size: geometry.size,
                    safeAreaInsets: geometry.safeAreaInsets
                )

                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            Text(String(localized: "shop.coin"))
                                .font(.headline)
                                .foregroundStyle(GameTheme.textSecondary)
                            Spacer()
                            StatusPill(title: "\(store.userData.coin)", systemImage: "centsign.circle.fill")
                        }
                        .glassCard()

                        ForEach(GameMaster.baits) { bait in
                            ShopBaitCard(
                                bait: bait,
                                isOwned: store.isOwned(baitId: bait.id),
                                isSelected: store.selectedBait.id == bait.id,
                                canAfford: store.userData.coin >= bait.price,
                                onPurchase: {
                                    _ = store.purchaseBait(bait)
                                },
                                onSelect: {
                                    store.selectBait(bait)
                                }
                            )
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle(String(localized: "shop.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    /// ショップ背景を返す。
    /// - Parameter size: 画面サイズ。
    /// - Parameter safeAreaInsets: セーフエリア余白。
    /// - Returns: 背景View。
    private func shopBackground(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
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

/// 餌カード。
private struct ShopBaitCard: View {
    /// 表示対象の餌。
    let bait: BaitMaster
    /// 所持済みかどうか。
    let isOwned: Bool
    /// 選択中かどうか。
    let isSelected: Bool
    /// 購入可能かどうか。
    let canAfford: Bool
    /// 購入アクション。
    let onPurchase: () -> Void
    /// 選択アクション。
    let onSelect: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color.white)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: bait.assetName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(GameTheme.mainBlue)
                )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(bait.name)
                        .font(.title3.bold())
                        .foregroundStyle(GameTheme.textPrimary)
                    if bait.id == "premium_bait" {
                        Text(String(localized: "shop.recommended"))
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(GameTheme.accentYellow, in: Capsule())
                    }
                }

                Text(bait.description)
                    .font(.subheadline)
                    .foregroundStyle(GameTheme.textSecondary)
                Text("\(String(localized: "shop.price")): \(bait.price)")
                    .font(.subheadline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
            }

            Spacer()

            if isSelected {
                BadgeButton(title: String(localized: "shop.selected"), color: GameTheme.mainBlue)
            } else if isOwned {
                Button(String(localized: "shop.select")) {
                    onSelect()
                }
                .buttonStyle(ActionCapsuleButtonStyle(color: GameTheme.subGreen))
            } else {
                Button(String(localized: "shop.purchase")) {
                    onPurchase()
                }
                .buttonStyle(ActionCapsuleButtonStyle(color: canAfford ? GameTheme.subGreen : GameTheme.textSecondary))
                .disabled(!canAfford)
            }
        }
        .glassCard()
    }
}
