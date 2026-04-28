import Foundation

/// 釣果登録処理の戻り値。
struct RegisterCatchUseCaseResult {
    /// 更新後のユーザーデータ。
    let userData: UserGameData
    /// 新規魚種かどうか。
    let isNewFish: Bool
    /// 新記録かどうか。
    let isNewRecord: Bool
}

/// 釣果登録処理のインターフェース。
protocol RegisterCatchUseCase {
    /// 釣果登録を反映した結果を返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - caughtFish: 登録する釣果。
    /// - Returns: 更新結果。
    func execute(userData: UserGameData, caughtFish: CaughtFish) -> RegisterCatchUseCaseResult
}

/// 釣果登録処理の実装。
struct RegisterCatchUseCaseImpl: RegisterCatchUseCase {
    /// 釣果登録を反映した結果を返す。
    /// - Parameters:
    ///   - userData: 現在のユーザーデータ。
    ///   - caughtFish: 登録する釣果。
    /// - Returns: 更新結果。
    func execute(userData: UserGameData, caughtFish: CaughtFish) -> RegisterCatchUseCaseResult {
        var updatedData = userData
        updatedData.coin += caughtFish.rewardCoin
        updatedData.catchHistory.insert(caughtFish, at: 0)

        var isNewFish = false
        var isNewRecord = false

        if let index = updatedData.encyclopedia.firstIndex(where: { $0.fishId == caughtFish.fishId }) {
            var entry = updatedData.encyclopedia[index]
            isNewFish = !entry.isUnlocked
            entry.isUnlocked = true
            entry.caughtCount += 1

            if let maxWeight = entry.maxWeight {
                if caughtFish.weight > maxWeight {
                    entry.maxWeight = caughtFish.weight
                    isNewRecord = true
                }
            } else {
                entry.maxWeight = caughtFish.weight
                entry.firstCaughtAt = caughtFish.caughtAt
                isNewRecord = true
            }

            if entry.firstCaughtAt == nil {
                entry.firstCaughtAt = caughtFish.caughtAt
            }

            updatedData.encyclopedia[index] = entry
        }

        return RegisterCatchUseCaseResult(
            userData: updatedData,
            isNewFish: isNewFish,
            isNewRecord: isNewRecord
        )
    }
}
