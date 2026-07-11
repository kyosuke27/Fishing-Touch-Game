import SwiftUI

/// ホーム画面を表示するScreen。
struct HomeScreen: View {
    /// 釣り画面表示状態。
    @Binding private var isFishingPresented: Bool
    /// ショップ画面表示状態。
    @Binding private var isShopPresented: Bool
    /// 共通保存値
    @ObservedObject private var store: GameSessionStore
    /// ホーム画面ViewModel。
    @StateObject private var viewModel: HomeScreenViewModel
    /// 現在のWindowに紐づく画面横幅。
    @State private var deviceWidth: CGFloat = 0
    /// 餌未選択ダイアログ表示状態。
    @State private var isBaitSelectionAlertPresented = false
    
    /// Screenを生成する。
    /// - Parameters:
    ///   - store: 共通ストア。
    ///   - isFishingPresented: 釣り画面表示状態。
    ///   - isShopPresented: ショップ画面表示状態。
    init(
        store: GameSessionStore,
        isFishingPresented: Binding<Bool>,
        isShopPresented: Binding<Bool>
    ) {
        self._isFishingPresented = isFishingPresented
        self._isShopPresented = isShopPresented
        self.store = store
        self._viewModel = StateObject(wrappedValue: HomeScreenViewModel(store: store))
    }
    
    /// 背景の上に重ねるコンテンツ領域の横幅。
    private var contentWidth: CGFloat {
        max(deviceWidth - 20, 0)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                homeBackground
                
                VStack(spacing: 18) {
                    topStatusRow
                    heroSection
                    startButton
                    progressCard
                    menuGrid
                }
                .frame(width: contentWidth, alignment: .topLeading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 18)
                .padding(.bottom, adOverlayReservedHeight(safeAreaBottom: geometry.safeAreaInsets.bottom))
                
                ScreenWidthReader(width: $deviceWidth)
                    .allowsHitTesting(false)
                    .overlay(alignment: .bottom) {
                        AdmobAnchoredBannerView(width: geometry.size.width)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                    }
            }
        }
        .navigationBarHidden(true)
        .alert(
            String(localized: "home.baitSelection.title"),
            isPresented: $isBaitSelectionAlertPresented,
            actions: {
                Button(String(localized: "common.ok")) {
                    isShopPresented = true
                }
            },
            message: {
                Text(String(localized: "home.baitSelection.message"))
            }
        )
    }
    
    /// ホーム専用背景。
    private var homeBackground: some View {
        ZStack {
            OceanBackground()
            Image("HomeBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.10),
                            Color.white.opacity(0.32),
                            GameTheme.background.opacity(0.72)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
    
    /// 上部ステータス表示。
    private var topStatusRow: some View {
        HStack(spacing: 12) {
            StatusCard(
                title: String(localized: "home.coin"),
                value: "\(viewModel.state.coin)",
                imageName: "Coin",
            )
            Spacer()
            StatusCard(
                title: String(localized: "home.selectedBait"),
                value: selectedBaitStatusText,
                imageName: store.selectedBait.imageName,
            )
        }
    }

    /// 選択中餌の表示文言。
    private var selectedBaitStatusText: String {
        guard viewModel.state.canStartFishing else {
            return String(localized: "home.selectedBait.empty")
        }

        return "\(viewModel.state.selectedBaitName) x\(viewModel.state.selectedBaitCount)"
    }
    
    /// タイトルと主導線のヒーローセクション。
    private var heroSection: some View {
        VStack(spacing: 0) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 140)
                .shadow(color: .white.opacity(0.45), radius: 14, x: 0, y: 8)
            
            Text(String(localized: "home.subtitle"))
                .font(.headline.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(GameTheme.textPrimary)
                .padding(.horizontal, 24)
            
            HStack(spacing: 14) {
                DecorativeFish(imageName: "Isaki")
                DecorativeFish(imageName: "Medaka")
                DecorativeFish(imageName: "Tai")
            }
        }
    }
    
    /// 釣り開始ボタン。
    private var startButton: some View {
        Button {
            guard store.consumeSelectedBait() else {
                isBaitSelectionAlertPresented = true
                return
            }

            isFishingPresented = true
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image("StartFishing")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipped()
            }
            .frame(width: 240, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: GameTheme.mainBlue.opacity(0.24), radius: 18, x: 0, y: 12)
        }
        .buttonStyle(.plain)
    }
    
    /// 進行状況カード。
    private var progressCard: some View {
        HStack(spacing: 14) {
            Image("Fish")
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(String(localized: "home.progress"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(GameTheme.textSecondary)
                Text("\(viewModel.state.unlockedFishCount) / \(GameMaster.fishes.count)")
                    .font(.title3.bold())
                    .foregroundStyle(GameTheme.textPrimary)
                Text(String(localized: "home.progress.caption"))
                    .font(.footnote)
                    .foregroundStyle(GameTheme.textSecondary)
            }
            
            Spacer()
        }
        .glassCard()
    }
    
    /// 画面遷移メニュー。
    private var menuGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
            NavigationLink {
                EncyclopediaScreen(store: store)
            } label: {
                HomeMenuButton(
                    imageName: "FishDictionaryButton"
                )
            }
            
            NavigationLink {
                CatchHistoryScreen(store: store)
            } label: {
                HomeMenuButton(
                    imageName: "FishList",
                )
            }
            
            NavigationLink {
                ShopScreen(store: store)
            } label: {
                HomeMenuButton(
                    imageName: "ShopButton"
                )
            }
        }
        .padding(.horizontal, 6)
    }
    
    /// 広告オーバーレイにホームメニューが隠れないための予約高さを返す。
    /// - Parameter safeAreaBottom: 画面下部のセーフエリア余白。
    /// - Returns: 画面下部に確保する余白の高さ。
    private func adOverlayReservedHeight(safeAreaBottom: CGFloat) -> CGFloat {
        96 + safeAreaBottom
    }
}
