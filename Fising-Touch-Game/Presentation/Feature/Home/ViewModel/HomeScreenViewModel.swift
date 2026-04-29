import Combine
import Foundation

/// ホーム画面の状態生成を担当するViewModel。
@MainActor
final class HomeScreenViewModel: ObservableObject {
    /// ホーム画面の表示状態。
    @Published private(set) var state: HomeState

    /// 共通ストア。
    private let store: GameSessionStore
    /// ストア監視用の購読保持。
    private var cancellables: Set<AnyCancellable> = []

    /// ViewModelを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
        self.state = Self.makeState(from: store)
        bindStore()
    }

    /// ストア変更を購読して状態を同期する。
    private func bindStore() {
        store.$userData
            .sink { [weak self] _ in
                guard let self else { return }
                state = Self.makeState(from: store)
            }
            .store(in: &cancellables)
    }

    /// ストアから画面状態を生成する。
    /// - Parameter store: 共通ストア。
    /// - Returns: 画面状態。
    private static func makeState(from store: GameSessionStore) -> HomeState {
        HomeState(
            coin: store.userData.coin,
            selectedBaitId: store.selectedBait.id,
            selectedBaitName: store.selectedBait.name,
            unlockedFishCount: store.unlockedFishCount
        )
    }
}
