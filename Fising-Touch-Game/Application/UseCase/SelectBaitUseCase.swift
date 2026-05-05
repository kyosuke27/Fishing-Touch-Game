import Foundation

/// 餌選択処理のインターフェース。
protocol SelectBaitUseCase {
    /// 餌選択を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 選択対象の餌。
    /// - Returns: 更新後ユーザーデータ。選択不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData?
}

/// 餌選択処理の実装。
struct SelectBaitUseCaseImpl: SelectBaitUseCase {
    /// 餌選択を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 選択対象の餌。
    /// - Returns: 更新後ユーザーデータ。選択不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData? {
        guard userData.baitQuantities[bait.id, default: 0] > 0 else {
            return nil
        }

        var updatedData = userData
        updatedData.selectedBaitId = bait.id
        return updatedData
    }
}
