import Foundation

/// ホーム画面の表示状態。
struct HomeState: Equatable {
    /// 所持コイン数。
    let coin: Int
    /// 選択中餌の名称。
    let selectedBaitName: String
    /// 選択中餌のアイコン名。
    let selectedBaitAssetName: String
    /// 解放済み魚種数。
    let unlockedFishCount: Int
}
