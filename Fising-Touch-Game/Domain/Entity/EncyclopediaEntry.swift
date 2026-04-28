import Foundation

/// 図鑑1件分の状態を表すエンティティ。
struct EncyclopediaEntry: Codable, Identifiable, Hashable {
    /// 図鑑行の識別子。
    let id: String
    /// 対応する魚マスタの識別子。
    let fishId: String
    /// 解放済みかどうか。
    var isUnlocked: Bool
    /// 釣った回数。
    var caughtCount: Int
    /// 最大重量。
    var maxWeight: Double?
    /// 初回獲得日時。
    var firstCaughtAt: Date?
}
