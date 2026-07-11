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

    /// レア度の低い順に並べた餌一覧。
    private var sortedBaits: [BaitMaster] {
        GameMaster.baits.sorted { lhs, rhs in
            if lhs.rarity == rhs.rarity {
                return lhs.price < rhs.price
            }

            return lhs.rarity < rhs.rarity
        }
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
                        ForEach(sortedBaits) { bait in
                            ShopBaitCard(
                                bait: bait,
                                quantity: store.baitCount(baitId: bait.id),
                                isSelected: store.selectedBait.id == bait.id && store.isOwned(baitId: bait.id),
                                canAfford: store.userData.coin >= bait.price,
                                onPurchase: {
                                    _ = store.purchaseBait(bait)
                                },
                                onSelect: {
                                    store.selectBait(bait)
                                }
                            )
                        }

                        Color.clear
                            .frame(height: 96 + geometry.safeAreaInsets.bottom)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle(String(localized: "shop.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 6) {
                    Image("Coin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)

                    Text("\(store.userData.coin)")
                        .font(.headline.bold())
                        .foregroundStyle(GameTheme.textPrimary)
                }
            }
        }
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
    /// 所持数。
    let quantity: Int
    /// 選択中かどうか。
    let isSelected: Bool
    /// 購入可能かどうか。
    let canAfford: Bool
    /// 購入アクション。
    let onPurchase: () -> Void
    /// 選択アクション。
    let onSelect: () -> Void
    
    /// 選択可能かどうか。
    private var canSelect: Bool {
        quantity > 0
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 14) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Image(bait.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(bait.name)
                            .font(.title3.bold())
                            .foregroundStyle(GameTheme.textPrimary)
                        Spacer(minLength: 0)
                        
                        if isSelected {
                            Image("BaitMark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 74, height: 48)
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 8) {
                        RarityStars(rarity: bait.rarity)
                            .font(.subheadline)
                            .foregroundStyle(GameTheme.textSecondary)
                        
                        Spacer(minLength: 0)
                        
                        Image("Coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text("\(bait.price)")
                            .font(.subheadline.bold())
                            .foregroundStyle(GameTheme.textPrimary)
                    }
                    
                    Text(bait.description)
                        .font(.subheadline)
                        .foregroundStyle(GameTheme.textSecondary)
                    
                }
            }
            HStack(alignment: .center, spacing: 10) {
                Text("\(String(localized: "shop.stock")): \(quantity)")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(GameTheme.textSecondary)
                
                Spacer(minLength: 0)
                
                if canSelect {
                    imageButton(
                        imageName: "SelectButton",
                        isEnabled: !isSelected,
                        action: onSelect
                    )
                }
                
                imageButton(
                    imageName: "PurchaseButton",
                    isEnabled: canAfford,
                    action: onPurchase
                )
            }
        }
        .glassCard()
    }
    
    /// 画像ボタンを返す。
    /// - Parameters:
    ///   - imageName: 表示画像名。
    ///   - isEnabled: 操作可能かどうか。
    ///   - action: タップ時処理。
    /// - Returns: ボタンView。
    private func imageButton(imageName: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: buttonImageSize(imageName: imageName).width,
                    height: buttonImageSize(imageName: imageName).height
                )
                .opacity(isEnabled ? 1.0 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    /// ボタン画像ごとの見た目サイズ補正値を返す。
    /// - Parameter imageName: 画像名。
    /// - Returns: 表示サイズ。
    private func buttonImageSize(imageName: String) -> CGSize {
        switch imageName {
        case "SelectButton":
            // 元画像の余白が大きいため、視覚サイズが揃うように少し拡大する。
            CGSize(width: 112, height: 54)

        default:
            CGSize(width: 86, height: 34)
        }
    }
}
