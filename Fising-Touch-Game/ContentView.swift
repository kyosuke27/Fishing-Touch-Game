//
//  ContentView.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppGameStore()
    @State private var showFishing = false
    @State private var showError = false

    var body: some View {
        NavigationStack {
            HomeView(showFishing: $showFishing)
                .environmentObject(store)
        }
        .tint(GameTheme.mainBlue)
        .fullScreenCover(isPresented: $showFishing) {
            FishingView(store: store)
        }
        .onChange(of: store.lastErrorMessage) { _, newValue in
            showError = newValue != nil
        }
        .alert("エラー", isPresented: $showError, actions: {
            Button("閉じる", role: .cancel) {
                showError = false
            }
        }, message: {
            Text(store.lastErrorMessage ?? "")
        })
    }
}

private struct HomeView: View {
    @EnvironmentObject private var store: AppGameStore
    @Binding var showFishing: Bool

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            OceanBackground()

            ScrollView {
                VStack(spacing: 20) {
                    topStatusRow
                    titleSection
                    startButton
                    LazyVGrid(columns: columns, spacing: 14) {
                        NavigationLink {
                            EncyclopediaView()
                                .environmentObject(store)
                        } label: {
                            HomeMenuButton(title: "魚図鑑", systemImage: "fish")
                        }

                        NavigationLink {
                            CatchHistoryView()
                                .environmentObject(store)
                        } label: {
                            HomeMenuButton(title: "釣果一覧", systemImage: "list.bullet.rectangle")
                        }

                        NavigationLink {
                            ShopView()
                                .environmentObject(store)
                        } label: {
                            HomeMenuButton(title: "ショップ", systemImage: "storefront")
                        }
                    }
                    .padding(.horizontal, 6)

                    Spacer(minLength: 180)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }

    private var topStatusRow: some View {
        HStack {
            StatusPill(title: "\(store.userData.coin)", systemImage: "centsign.circle.fill")
            Spacer()
            StatusPill(title: store.selectedBait.name, systemImage: store.selectedBait.assetName)
        }
    }

    private var titleSection: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.white.opacity(0.9))
                    .frame(height: 190)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.white.opacity(0.8), lineWidth: 2)
                    )
                VStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "fish.fill")
                            .font(.system(size: 34))
                            .foregroundStyle(GameTheme.accentYellow)
                        Text("お手軽\nフィッシング")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(GameTheme.mainBlue)
                    }
                    Text("タップで気軽に釣って、図鑑を集めよう")
                        .font(.headline)
                        .foregroundStyle(GameTheme.textPrimary)
                }
                .padding()
            }

            HStack(spacing: 20) {
                DecorativeFish(systemName: "fish.fill", color: .red)
                DecorativeFish(systemName: "fish.circle.fill", color: GameTheme.accentYellow)
                DecorativeFish(systemName: "fish", color: GameTheme.mainBlue)
            }
        }
    }

    private var startButton: some View {
        Button {
            showFishing = true
        } label: {
            Text("釣りを始める")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(
                    LinearGradient(
                        colors: [GameTheme.mainBlue, Color.blue.opacity(0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    in: RoundedRectangle(cornerRadius: 28, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.75), lineWidth: 2)
                )
                .shadow(color: GameTheme.mainBlue.opacity(0.25), radius: 20, x: 0, y: 12)
        }
        .buttonStyle(.plain)
    }
}

private struct FishingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: AppGameStore
    @StateObject private var viewModel: FishingViewModel
    @State private var lastUpdate: Date?

    init(store: AppGameStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: FishingViewModel(store: store))
    }

    var body: some View {
        ZStack {
            OceanBackground()

            VStack(spacing: 22) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(GameTheme.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(.white.opacity(0.88), in: Circle())
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        StatusPill(title: "\(store.userData.coin)", systemImage: "centsign.circle.fill")
                        StatusPill(title: store.selectedBait.name, systemImage: store.selectedBait.assetName)
                    }
                }

                VStack(spacing: 12) {
                    CounterCard(title: "ヒット", value: "\(viewModel.successCount) / \(viewModel.targetFish.requiredHits)")
                    CounterCard(title: "連続成功", value: "\(viewModel.successCount)")
                }

                Spacer(minLength: 20)

                VStack(spacing: 26) {
                    fishPreview
                    hitBar
                    tapButton
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)

            if let result = viewModel.result {
                ResultOverlay(
                    result: result,
                    onRetry: {
                        viewModel.restart()
                        lastUpdate = nil
                    },
                    onClose: {
                        dismiss()
                    }
                )
            }
        }
        .onReceive(timer) { date in
            let delta = date.timeIntervalSince(lastUpdate ?? date)
            lastUpdate = date
            viewModel.update(deltaTime: delta)
        }
    }

    private let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()

    private var fishPreview: some View {
        VStack(spacing: 10) {
            FishBadge(fish: viewModel.targetFish, size: 92)
            Text("狙い: \(viewModel.targetFish.name)")
                .font(.title3.bold())
                .foregroundStyle(GameTheme.textPrimary)
            Text("想定重量 \(viewModel.currentWeight.formattedWeight)")
                .font(.headline)
                .foregroundStyle(GameTheme.textSecondary)
        }
    }

    private var hitBar: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let zoneWidth = width * viewModel.targetFish.hitZoneWidth
            let zoneX = (width * viewModel.hitZoneCenter) - (zoneWidth / 2)
            let barX = max(0, min(width - 12, width * viewModel.barPosition))

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
                        Text("ヒット!")
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

    private var tapButton: some View {
        Button {
            viewModel.tap()
        } label: {
            Text("タップ")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    LinearGradient(
                        colors: [GameTheme.mainBlue, Color.blue.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    in: RoundedRectangle(cornerRadius: 30, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(.white.opacity(0.75), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.result != nil)
    }
}

private struct EncyclopediaView: View {
    @EnvironmentObject private var store: AppGameStore

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            OceanBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("魚図鑑")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.textPrimary)
                        Text("達成率 \(store.unlockedFishCount) / \(GameMaster.fishes.count)")
                            .font(.headline)
                            .foregroundStyle(GameTheme.textSecondary)
                    }
                    .glassCard()

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(GameMaster.fishes) { fish in
                            if let entry = store.encyclopediaEntry(for: fish.id), entry.isUnlocked {
                                NavigationLink {
                                    FishDetailView(fish: fish, entry: entry)
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

private struct FishDetailView: View {
    let fish: FishMaster
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
                        Label("説明", systemImage: "text.alignleft")
                            .font(.headline)
                            .foregroundStyle(GameTheme.textPrimary)
                        Text(fish.description)
                            .foregroundStyle(GameTheme.textSecondary)
                        Divider()
                        DetailRow(title: "最大記録重量", value: entry.maxWeight?.formattedWeight ?? "-")
                        DetailRow(title: "釣った回数", value: "\(entry.caughtCount)回")
                        DetailRow(title: "必要ヒット数", value: "\(fish.requiredHits)")
                    }
                    .glassCard()
                }
                .padding(20)
            }
        }
        .navigationTitle("魚詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CatchHistoryView: View {
    @EnvironmentObject private var store: AppGameStore

    var body: some View {
        ZStack {
            OceanBackground()
            if store.userData.catchHistory.isEmpty {
                ContentUnavailableView(
                    "まだ釣果がありません",
                    systemImage: "fish",
                    description: Text("ホームから釣りを始めるとここに履歴が表示されます。")
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
        .navigationTitle("釣果一覧")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ShopView: View {
    @EnvironmentObject private var store: AppGameStore

    var body: some View {
        ZStack {
            OceanBackground()
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text("所持コイン")
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
        .navigationTitle("ショップ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ResultOverlay: View {
    let result: FishingResult
    let onRetry: () -> Void
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
                        Text("釣れた！")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.textPrimary)
                        Text(catchRecord.fishName)
                            .font(.title.bold())
                            .foregroundStyle(GameTheme.mainBlue)
                        RarityStars(rarity: catchRecord.rarity)
                    }
                    VStack(spacing: 10) {
                        DetailRow(title: "重量", value: catchRecord.weight.formattedWeight)
                        DetailRow(title: "獲得コイン", value: "\(catchRecord.rewardCoin)")
                        DetailRow(title: "図鑑", value: isNewFish ? "NEW" : "登録済み")
                        if isNewRecord {
                            DetailRow(title: "記録", value: "ベスト更新")
                        }
                    }
                case let .failure(target):
                    FishBadge(fish: target, size: 110)
                    VStack(spacing: 8) {
                        Text("逃げられた…")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.warning)
                        Text(target.name)
                            .font(.title2.bold())
                            .foregroundStyle(GameTheme.textPrimary)
                    }
                }

                VStack(spacing: 12) {
                    ResultButton(title: "もう一度釣る", color: GameTheme.mainBlue, action: onRetry)
                    ResultButton(title: "ホームへ戻る", color: GameTheme.subGreen, action: onClose)
                }
            }
            .frame(maxWidth: 340)
            .glassCard()
            .padding(20)
        }
    }
}

private struct StatusPill: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(GameTheme.accentYellow)
            Text(title)
                .font(.headline.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            LinearGradient(colors: [GameTheme.mainBlue, Color.blue.opacity(0.85)], startPoint: .top, endPoint: .bottom),
            in: Capsule()
        )
    }
}

private struct HomeMenuButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2.bold())
            Text(title)
                .font(.headline.bold())
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            LinearGradient(colors: [GameTheme.subGreen, Color.green.opacity(0.85)], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.85), lineWidth: 2)
        )
    }
}

private struct CounterCard: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(GameTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(GameTheme.textPrimary)
        }
        .glassCard()
    }
}

private struct FishBadge: View {
    let fish: FishMaster
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, rarityColor.opacity(0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            Image(systemName: fish.assetName)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(rarityColor)
        }
        .shadow(color: rarityColor.opacity(0.22), radius: 12, x: 0, y: 8)
    }

    private var rarityColor: Color {
        switch fish.rarity {
        case 3: GameTheme.accentYellow
        case 2: GameTheme.subGreen
        default: GameTheme.mainBlue
        }
    }
}

private struct RarityStars: View {
    let rarity: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<rarity, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundStyle(GameTheme.accentYellow)
            }
        }
    }
}

private struct EncyclopediaCard: View {
    let fish: FishMaster
    let entry: EncyclopediaEntry

    var body: some View {
        VStack(spacing: 12) {
            FishBadge(fish: fish, size: 88)
            Text(fish.name)
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textPrimary)
            RarityStars(rarity: fish.rarity)
            Text("\(entry.caughtCount)回")
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }
}

private struct LockedFishCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.75))
                .frame(width: 88, height: 88)
                .overlay(Image(systemName: "questionmark").font(.system(size: 28, weight: .bold)).foregroundStyle(GameTheme.textSecondary))
            Text("未発見")
                .font(.headline.bold())
                .foregroundStyle(GameTheme.textSecondary)
            Text("???")
                .font(.subheadline)
                .foregroundStyle(GameTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }
}

private struct CatchHistoryCard: View {
    let catchRecord: CaughtFish
    let fish: FishMaster?

    var body: some View {
        HStack(spacing: 14) {
            FishBadge(fish: fish ?? GameMaster.fishes[0], size: 64)
            VStack(alignment: .leading, spacing: 6) {
                Text(catchRecord.fishName)
                    .font(.headline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                Text("\(catchRecord.weight.formattedWeight) / コイン \(catchRecord.rewardCoin)")
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

private struct ShopBaitCard: View {
    let bait: BaitMaster
    let isOwned: Bool
    let isSelected: Bool
    let canAfford: Bool
    let onPurchase: () -> Void
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
                        Text("おすすめ")
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
                Text("価格: \(bait.price)")
                    .font(.subheadline.bold())
                    .foregroundStyle(GameTheme.textPrimary)
            }

            Spacer()

            if isSelected {
                BadgeButton(title: "選択中", color: GameTheme.mainBlue)
            } else if isOwned {
                Button("選択") {
                    onSelect()
                }
                .buttonStyle(ActionCapsuleButtonStyle(color: GameTheme.subGreen))
            } else {
                Button("購入") {
                    onPurchase()
                }
                .buttonStyle(ActionCapsuleButtonStyle(color: canAfford ? GameTheme.subGreen : GameTheme.textSecondary))
                .disabled(!canAfford)
            }
        }
        .glassCard()
    }
}

private struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(GameTheme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(GameTheme.textPrimary)
        }
    }
}

private struct ResultButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .buttonStyle(ActionCapsuleButtonStyle(color: color))
    }
}

private struct BadgeButton: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(color, in: Capsule())
    }
}

private struct ActionCapsuleButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(color.opacity(configuration.isPressed ? 0.82 : 1), in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

private struct DecorativeFish: View {
    let systemName: String
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(color)
            .padding(14)
            .background(.white.opacity(0.72), in: Circle())
    }
}

private extension Double {
    var formattedWeight: String {
        "\(self.formatted(.number.precision(.fractionLength(2))))kg"
    }
}
