import Combine
import SwiftUI

/// 釣りミニゲーム画面。
struct FishingScreen: View {
    /// 画面を閉じるための環境値。
    @Environment(\.dismiss) private var dismiss
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore
    /// 釣り画面ViewModel。
    @StateObject private var viewModel: FishingScreenViewModel
    /// 前フレーム時刻。
    @State private var lastUpdate: Date?

    /// 描画更新タイマー。
    private let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()

    /// Screenを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
        self._viewModel = StateObject(wrappedValue: FishingScreenViewModel(store: store))
    }

    /// 選択中餌の表示画像名。
    private var baitImageName: String {
        switch store.selectedBait.id {
        case "premium_bait":
            "Ebi"
        default:
            "Esa"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                fishingBackground(size: geometry.size)

                VStack(spacing: 22) {
                    header
                    counters
                    Spacer(minLength: 20)
                    fishingArea(size: geometry.size)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)

                if let result = viewModel.state.result {
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
        }
        .ignoresSafeArea()
        .onReceive(timer) { date in
            let delta = date.timeIntervalSince(lastUpdate ?? date)
            lastUpdate = date
            viewModel.update(deltaTime: delta)
        }
    }

    /// 釣り画面の背景を表示する。
    /// - Parameter size: 画面の表示サイズ。
    /// - Returns: クリップ済み背景View。
    private func fishingBackground(size: CGSize) -> some View {
        Image("HomeBackground")
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height, alignment: .topLeading)
            .clipped()
            .ignoresSafeArea()
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.10),
                        Color.white.opacity(0.24),
                        GameTheme.background.opacity(0.58)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    /// ヘッダー表示。
    private var header: some View {
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
                FishingStatusCard(
                    title: String(localized: "home.coin"),
                    value: "\(store.userData.coin)",
                    imageName: "Coin"
                )
                FishingStatusCard(
                    title: String(localized: "home.selectedBait"),
                    value: store.selectedBait.name,
                    imageName: baitImageName
                )
            }
        }
    }

    /// カウンター表示。
    private var counters: some View {
        VStack(spacing: 12) {
            CounterCard(
                title: String(localized: "fishing.counter.hit"),
                value: "\(viewModel.state.successCount) / \(viewModel.state.targetFish.requiredHits)"
            )
            CounterCard(
                title: String(localized: "fishing.counter.combo"),
                value: "\(viewModel.state.successCount)"
            )
        }
    }

    /// 釣り操作エリア。
    /// 釣り操作エリアを表示する。
    /// - Parameter size: 親画面の表示サイズ。
    /// - Returns: 釣り操作エリアView。
    private func fishingArea(size: CGSize) -> some View {
        VStack(spacing: 26) {
            VStack(spacing: 10) {
                FishBadge(fish: viewModel.state.targetFish, size: 92)
                Text("\(String(localized: "fishing.target")): \(viewModel.state.targetFish.name)")
                    .font(.title3.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                Text("\(String(localized: "fishing.weight")) \(viewModel.state.currentWeight.formattedWeight)")
                    .font(.headline)
                    .foregroundStyle(GameTheme.textSecondary)
            }

            FishingHitBar(state: viewModel.state)

            Button {
                viewModel.tap()
            } label: {
                Image("TapButton")
                    .resizable()
                    .scaledToFill()
                    .frame(width:size.width*0.5,height: size.height*0.1)
                    .opacity(viewModel.state.result != nil ? 0.6 : 1)
                    .background(.gray)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.state.result != nil)
        }
    }
}
