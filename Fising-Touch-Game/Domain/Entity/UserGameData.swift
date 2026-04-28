import Foundation

/// ユーザーのゲーム進行状況全体を保持するエンティティ。
struct UserGameData: Codable, Equatable {
    /// 所持コイン数。
    var coin: Int
    /// 現在選択中の餌ID。
    var selectedBaitId: String
    /// 所持済み餌ID一覧。
    var ownedBaitIds: [String]
    /// 釣果履歴一覧。
    var catchHistory: [CaughtFish]
    /// 図鑑状態一覧。
    var encyclopedia: [EncyclopediaEntry]
}
