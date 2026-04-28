import Foundation

/// 釣果履歴1件分を表すエンティティ。
struct CaughtFish: Codable, Identifiable, Hashable {
    /// 履歴の識別子。
    let id: String
    /// 魚マスタの識別子。
    let fishId: String
    /// 釣れた魚の表示名。
    let fishName: String
    /// 釣れた魚のレアリティ。
    let rarity: Int
    /// 釣れた重量。
    let weight: Double
    /// 獲得コイン数。
    let rewardCoin: Int
    /// 釣れた日時。
    let caughtAt: Date
}
