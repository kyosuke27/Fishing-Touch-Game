import Foundation

/// 餌消費処理のインターフェース。
protocol ConsumeBaitUseCase {
    /// 餌消費を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 消費対象の餌。
    /// - Returns: 更新後ユーザーデータ。消費不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData?
}

/// 餌消費処理の実装。
struct ConsumeBaitUseCaseImpl: ConsumeBaitUseCase {
    /// 餌消費を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 消費対象の餌。
    /// - Returns: 更新後ユーザーデータ。消費不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData? {
        guard userData.baitQuantities[bait.id, default: 0] > 0 else {
            return nil
        }

        var updatedData = userData
        updatedData.baitQuantities[bait.id, default: 0] -= 1
        return updatedData
    }
}
