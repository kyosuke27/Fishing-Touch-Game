import Foundation

/// 釣り画面の表示状態。
struct FishingState: Equatable {
    /// 狙っている魚。
    var targetFish: FishMaster
    /// 現在の重量。
    var currentWeight: Double
    /// 成功回数。
    var successCount: Int
    /// バー位置。
    var barPosition: Double
    /// ヒットエリア中心位置。
    var hitZoneCenter: Double
    /// 現在の結果。
    var result: FishingResult?
    /// 実行中かどうか。
    var isRunning: Bool
}
