import Foundation

/// 魚マスタ情報を表すエンティティ。
struct FishMaster: Codable, Identifiable, Hashable {
    /// 魚の識別子。
    let id: String
    /// 魚の表示名。
    let name: String
    /// 魚のレアリティ。
    let rarity: Int
    /// 魚の説明文。
    let description: String
    /// 釣り成功に必要なヒット回数。
    let requiredHits: Int
    /// ヒット判定エリアの幅。
    let hitZoneWidth: Double
    /// バー移動速度。
    let barSpeed: Double
    /// 最小重量。
    let minWeight: Double
    /// 最大重量。
    let maxWeight: Double
    /// 獲得コイン数。
    let rewardCoin: Int
    /// 表示用のSF Symbols名。
    let assetName: String
}
