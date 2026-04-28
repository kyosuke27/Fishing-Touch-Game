import Foundation

/// 餌購入処理のインターフェース。
protocol PurchaseBaitUseCase {
    /// 餌購入を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 購入対象の餌。
    /// - Returns: 更新後ユーザーデータ。購入不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData?
}

/// 餌購入処理の実装。
struct PurchaseBaitUseCaseImpl: PurchaseBaitUseCase {
    /// 餌購入を反映したユーザーデータを返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - bait: 購入対象の餌。
    /// - Returns: 更新後ユーザーデータ。購入不可の場合は`nil`。
    func execute(userData: UserGameData, bait: BaitMaster) -> UserGameData? {
        guard !userData.ownedBaitIds.contains(bait.id), userData.coin >= bait.price else {
            return nil
        }

        var updatedData = userData
        updatedData.coin -= bait.price
        updatedData.ownedBaitIds.append(bait.id)
        return updatedData
    }
}
