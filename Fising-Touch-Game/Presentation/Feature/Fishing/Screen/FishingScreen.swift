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
    /// 再挑戦時に表示するインタースティシャル広告ViewModel。
    @StateObject private var interstitialViewModel = InterstitialViewModel()
    /// 前フレーム時刻。
    @State private var lastUpdate: Date?
    /// 餌未選択ダイアログ表示状態。
    @State private var isBaitSelectionAlertPresented = false
    /// 餌選択が必要な時に実行する処理。
    private let onBaitSelectionRequired: () -> Void

    /// 描画更新タイマー。
    private let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()

    /// Screenを生成する。
    /// - Parameters:
    ///   - store: 共通ストア。
    ///   - onBaitSelectionRequired: 餌選択が必要な時に実行する処理。
    init(store: GameSessionStore, onBaitSelectionRequired: @escaping () -> Void) {
        self.store = store
        self.onBaitSelectionRequired = onBaitSelectionRequired
        self._viewModel = StateObject(wrappedValue: FishingScreenViewModel(store: store))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                fishingBackground(size: geometry.size)

                VStack(spacing: 22) {
                    header
                    counters
                    Spacer(minLength: 20)
                    fishingArea(size: geometry.size)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 42)
                .padding(.bottom, adOverlayReservedHeight(safeAreaBottom: geometry.safeAreaInsets.bottom))
                .frame(width: geometry.size.width, alignment: .topLeading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                AdmobAnchoredBannerView(width: geometry.size.width)
                    .padding(.bottom, adOverlayBottomPadding(safeAreaBottom: geometry.safeAreaInsets.bottom))

                if let result = viewModel.state.result {
                    ResultOverlay(
                        result: result,
                        onRetry: {
                            guard store.consumeSelectedBait() else {
                                isBaitSelectionAlertPresented = true
                                return
                            }

                            interstitialViewModel.presentRandomIfAvailable {
                                viewModel.restart()
                                lastUpdate = nil
                            }
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
            // 前時刻からの変化値
            let delta = date.timeIntervalSince(lastUpdate ?? date)
            lastUpdate = date
            viewModel.update(deltaTime: delta)
        }
        .onAppear {
            // 再挑戦時に待ち時間を出さないよう事前ロードする。
            interstitialViewModel.load()
        }
        .alert(
            String(localized: "home.baitSelection.title"),
            isPresented: $isBaitSelectionAlertPresented,
            actions: {
                Button(String(localized: "common.ok")) {
                    onBaitSelectionRequired()
                }
            },
            message: {
                Text(String(localized: "home.baitSelection.message"))
            }
        )
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
            StatusCard(
                title: String(localized: "home.coin"),
                value: "\(store.userData.coin)",
                imageName: "Coin"
            )
            Spacer()
            StatusCard(
                title: String(localized: "home.selectedBait"),
                value: store.selectedBait.name,
                imageName: store.selectedBait.imageName
            )
        }
    }

    /// カウンター表示。
    private var counters: some View {
        VStack(spacing: 12) {
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
                FishBadge(fish: viewModel.state.targetFish, size: 92, isHidden: true)
            }

            FishingHitBar(state: viewModel.state)

            Button {
                viewModel.tap()
            } label: {
                Image("TapButton")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width * 0.5, height: size.height * 0.1)
                    .opacity(viewModel.state.result != nil ? 0.6 : 1)
                    .background(.gray)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.state.result != nil)
        }
    }

    /// 広告オーバーレイに釣り操作エリアが隠れないための予約高さを返す。
    /// - Parameter safeAreaBottom: 画面下部のセーフエリア余白。
    /// - Returns: 画面下部に確保する余白の高さ。
    private func adOverlayReservedHeight(safeAreaBottom: CGFloat) -> CGFloat {
        96 + adOverlayBottomPadding(safeAreaBottom: safeAreaBottom)
    }

    /// 広告オーバーレイの下に確保する余白を返す。
    /// - Parameter safeAreaBottom: 画面下部のセーフエリア余白。
    /// - Returns: 広告下部に確保する余白の高さ。
    private func adOverlayBottomPadding(safeAreaBottom: CGFloat) -> CGFloat {
        // 全画面表示時もHomeScreenと同じように広告下の余白を残す。
        max(safeAreaBottom, 12)
    }
}
