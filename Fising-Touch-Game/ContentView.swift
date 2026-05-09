import Foundation
import SwiftUI

/// アプリ全体の画面遷移と共通状態を束ねるルートビュー。
struct ContentView: View {
    /// 永続化済みのゲーム状態を共有するストア。
    @StateObject private var store = GameSessionStore()
    /// 釣り画面の表示状態。
    @State private var isFishingPresented = false
    /// ショップ画面の表示状態。
    @State private var isShopPresented = false
    /// エラー表示状態。
    @State private var isErrorPresented = false

    var body: some View {
        NavigationStack {
            HomeScreen(
                store: store,
                isFishingPresented: $isFishingPresented,
                isShopPresented: $isShopPresented
            )
            .navigationDestination(isPresented: $isShopPresented) {
                ShopScreen(store: store)
            }
        }
        .tint(GameTheme.mainBlue)
        .fullScreenCover(isPresented: $isFishingPresented) {
            FishingScreen(store: store) {
                isFishingPresented = false

                // 釣り画面を閉じた後にショップへ遷移する。
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    isShopPresented = true
                }
            }
        }
        .onChange(of: store.lastErrorMessage) { _, newValue in
            isErrorPresented = newValue != nil
        }
        .alert(
            String(localized: "common.error.title"),
            isPresented: $isErrorPresented,
            actions: {
                Button(String(localized: "common.close"), role: .cancel) {
                    isErrorPresented = false
                }
            },
            message: {
                Text(store.lastErrorMessage ?? "")
            }
        )
    }
}
