import Foundation

/// 餌マスタ情報を表すエンティティ。
struct BaitMaster: Codable, Identifiable, Hashable {
    /// 餌の識別子。
    let id: String
    /// 餌の表示名。
    let name: String
    /// 餌の説明文。
    let description: String
    /// 購入価格。
    let price: Int
    /// 魚ごとの抽選重み。
    let rarityWeights: [String: Int]
    /// 表示用のSF Symbols名。
    let assetName: String
}
