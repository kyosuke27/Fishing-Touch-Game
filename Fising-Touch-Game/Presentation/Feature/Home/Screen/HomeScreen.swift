import SwiftUI

/// ホーム画面を表示するScreen。
struct HomeScreen: View {
    /// 釣り画面表示状態。
    @Binding private var isFishingPresented: Bool
    /// 共通ストア。
    @ObservedObject private var store: GameSessionStore
    /// ホーム画面ViewModel。
    @StateObject private var viewModel: HomeScreenViewModel

    /// メニューのグリッド定義。
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    /// Screenを生成する。
    /// - Parameters:
    ///   - store: 共通ストア。
    ///   - isFishingPresented: 釣り画面表示状態。
    init(store: GameSessionStore, isFishingPresented: Binding<Bool>) {
        self._isFishingPresented = isFishingPresented
        self.store = store
        self._viewModel = StateObject(wrappedValue: HomeScreenViewModel(store: store))
    }

    var body: some View {
        ZStack {
            OceanBackground()

            ScrollView {
                VStack(spacing: 20) {
                    topStatusRow
                    titleSection
                    startButton
                    menuGrid
                    Spacer(minLength: 180)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }

    /// 上部ステータス表示。
    private var topStatusRow: some View {
        HStack {
            StatusPill(title: "\(viewModel.state.coin)", systemImage: "centsign.circle.fill")
            Spacer()
            StatusPill(
                title: viewModel.state.selectedBaitName,
                systemImage: viewModel.state.selectedBaitAssetName
            )
        }
    }

    /// タイトル表示セクション。
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
                        Text(String(localized: "home.title"))
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(GameTheme.mainBlue)
                    }

                    Text(String(localized: "home.subtitle"))
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

    /// 釣り開始ボタン。
    private var startButton: some View {
        Button {
            isFishingPresented = true
        } label: {
            Text(String(localized: "home.startFishing"))
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

    /// 画面遷移メニュー。
    private var menuGrid: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            NavigationLink {
                EncyclopediaScreen(store: store)
            } label: {
                HomeMenuButton(title: String(localized: "home.menu.encyclopedia"), systemImage: "fish")
            }

            NavigationLink {
                CatchHistoryScreen(store: store)
            } label: {
                HomeMenuButton(title: String(localized: "home.menu.history"), systemImage: "list.bullet.rectangle")
            }

            NavigationLink {
                ShopScreen(store: store)
            } label: {
                HomeMenuButton(title: String(localized: "home.menu.shop"), systemImage: "storefront")
            }
        }
        .padding(.horizontal, 6)
    }
}
