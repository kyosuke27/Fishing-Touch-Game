import Foundation

/// 釣りミニゲームの結果を表す値。
enum FishingResult: Equatable {
    /// 成功時の結果。
    case success(catch: CaughtFish, isNewRecord: Bool, isNewFish: Bool)
    /// 失敗時の結果。
    case failure(target: FishMaster)
}
