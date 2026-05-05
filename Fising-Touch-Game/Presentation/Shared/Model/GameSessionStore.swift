import Combine
import Foundation

/// 画面横断で利用するゲーム進行状態のストア。
@MainActor
final class GameSessionStore: ObservableObject {
    /// 現在のユーザーデータ。
    @Published private(set) var userData: UserGameData
    /// 最後に発生したエラーメッセージ。
    @Published private(set) var lastErrorMessage: String?

    /// データ読み込みUseCase。
    private let loadUserGameDataUseCase: LoadUserGameDataUseCase
    /// データ保存UseCase。
    private let saveUserGameDataUseCase: SaveUserGameDataUseCase
    /// 餌購入UseCase。
    private let purchaseBaitUseCase: PurchaseBaitUseCase
    /// 餌選択UseCase。
    private let selectBaitUseCase: SelectBaitUseCase
    /// 釣果登録UseCase。
    private let registerCatchUseCase: RegisterCatchUseCase

    /// ストアを生成する。
    /// - Parameters:
    ///   - repository: 利用するリポジトリ。
    ///   - purchaseBaitUseCase: 餌購入UseCase。
    ///   - selectBaitUseCase: 餌選択UseCase。
    ///   - registerCatchUseCase: 釣果登録UseCase。
    init(
        repository: UserGameDataRepository? = nil,
        purchaseBaitUseCase: PurchaseBaitUseCase? = nil,
        selectBaitUseCase: SelectBaitUseCase? = nil,
        registerCatchUseCase: RegisterCatchUseCase? = nil
    ) {
        let resolvedRepository = repository ?? UserGameDataRepositoryImpl()
        self.loadUserGameDataUseCase = LoadUserGameDataUseCaseImpl(repository: resolvedRepository)
        self.saveUserGameDataUseCase = SaveUserGameDataUseCaseImpl(repository: resolvedRepository)
        self.purchaseBaitUseCase = purchaseBaitUseCase ?? PurchaseBaitUseCaseImpl()
        self.selectBaitUseCase = selectBaitUseCase ?? SelectBaitUseCaseImpl()
        self.registerCatchUseCase = registerCatchUseCase ?? RegisterCatchUseCaseImpl()

        do {
            self.userData = try loadUserGameDataUseCase.execute()
        } catch {
            self.userData = GameMaster.initialData
            self.lastErrorMessage = String(localized: "error.load.default")
            try? saveUserGameDataUseCase.execute(data: self.userData)
        }
    }

    /// 現在選択中の餌を返す。
    var selectedBait: BaitMaster {
        GameMaster.bait(id: userData.selectedBaitId) ?? GameMaster.baits[0]
    }

    /// 解放済み魚種数を返す。
    var unlockedFishCount: Int {
        userData.encyclopedia.filter(\.isUnlocked).count
    }

    /// 指定の餌を所持しているか返す。
    /// - Parameter baitId: 餌ID。
    /// - Returns: 所持していれば`true`。
    func isOwned(baitId: String) -> Bool {
        baitCount(baitId: baitId) > 0
    }

    /// 指定の餌の所持数を返す。
    /// - Parameter baitId: 餌ID。
    /// - Returns: 所持数。
    func baitCount(baitId: String) -> Int {
        userData.baitQuantities[baitId, default: 0]
    }

    /// 餌購入を反映する。
    /// - Parameter bait: 購入対象の餌。
    /// - Returns: 購入成功時は`true`。
    func purchaseBait(_ bait: BaitMaster) -> Bool {
        guard let updatedData = purchaseBaitUseCase.execute(userData: userData, bait: bait) else {
            return false
        }

        userData = updatedData
        persist()
        return true
    }

    /// 餌選択を反映する。
    /// - Parameter bait: 選択対象の餌。
    func selectBait(_ bait: BaitMaster) {
        guard let updatedData = selectBaitUseCase.execute(userData: userData, bait: bait) else {
            return
        }

        userData = updatedData
        persist()
    }

    /// 釣果を登録する。
    /// - Parameter caughtFish: 登録対象の釣果。
    /// - Returns: 新規魚種か新記録かを含む更新結果。
    func registerCatch(_ caughtFish: CaughtFish) -> (isNewFish: Bool, isNewRecord: Bool) {
        let result = registerCatchUseCase.execute(userData: userData, caughtFish: caughtFish)
        userData = result.userData
        persist()
        return (result.isNewFish, result.isNewRecord)
    }

    /// 魚IDからマスタを返す。
    /// - Parameter fishId: 魚ID。
    /// - Returns: 見つかった魚マスタ。
    func fishMaster(for fishId: String) -> FishMaster? {
        GameMaster.fish(id: fishId)
    }

    /// 魚IDから図鑑エントリを返す。
    /// - Parameter fishId: 魚ID。
    /// - Returns: 見つかった図鑑エントリ。
    func encyclopediaEntry(for fishId: String) -> EncyclopediaEntry? {
        userData.encyclopedia.first { $0.fishId == fishId }
    }

    /// 現在状態を永続化する。
    private func persist() {
        do {
            try saveUserGameDataUseCase.execute(data: userData)
            lastErrorMessage = nil
        } catch {
            lastErrorMessage = String(localized: "error.save.default")
        }
    }
}
