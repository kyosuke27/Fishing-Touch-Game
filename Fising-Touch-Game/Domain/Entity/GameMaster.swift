import Foundation

/// ゲーム内で固定のマスタデータを提供する定義群。
enum GameMaster {
    /// 魚マスタ一覧。
    static let fishes: [FishMaster] = [
        FishMaster(
            id: "medaka",
            name: "メダカ",
            rarity: 1,
            description: "初心者向けの小さな魚",
            requiredHits: 1,
            hitZoneWidth: 0.30,
            barSpeed: 1.8,
            minWeight: 0.1,
            maxWeight: 0.3,
            rewardCoin: 50,
            assetName: "fish"
        ),
        FishMaster(
            id: "aji",
            name: "アジ",
            rarity: 2,
            description: "バランスのよい基準魚",
            requiredHits: 3,
            hitZoneWidth: 0.20,
            barSpeed: 1.3,
            minWeight: 0.3,
            maxWeight: 1.0,
            rewardCoin: 100,
            assetName: "fish.fill"
        ),
        FishMaster(
            id: "tai",
            name: "タイ",
            rarity: 3,
            description: "レア感と達成感を演出する目玉魚",
            requiredHits: 5,
            hitZoneWidth: 0.12,
            barSpeed: 0.95,
            minWeight: 2.0,
            maxWeight: 5.0,
            rewardCoin: 150,
            assetName: "fish.circle.fill"
        )
    ]

    /// 餌マスタ一覧。
    static let baits: [BaitMaster] = [
        BaitMaster(
            id: "normal_bait",
            name: "アオイソメ",
            description: "普通のイソメ。特別な効果はない。",
            price: 0,
            rarityWeights: ["medaka": 50, "aji": 35, "tai": 15],
            assetName: "leaf.fill"
        ),
        BaitMaster(
            id: "premium_bait",
            name: "エビ",
            description: "レアな魚と出会いやすくなる。",
            price: 1500,
            rarityWeights: ["medaka": 25, "aji": 40, "tai": 35],
            assetName: "drop.fill"
        )
    ]

    /// 初期ユーザーデータ。
    static let initialData = UserGameData(
        coin: 500,
        selectedBaitId: "normal_bait",
        ownedBaitIds: ["normal_bait"],
        catchHistory: [],
        encyclopedia: fishes.map {
            EncyclopediaEntry(
                id: $0.id,
                fishId: $0.id,
                isUnlocked: false,
                caughtCount: 0,
                maxWeight: nil,
                firstCaughtAt: nil
            )
        }
    )

    /// 魚IDからマスタを取得する。
    /// - Parameter id: 魚ID。
    /// - Returns: 見つかった魚マスタ。
    static func fish(id: String) -> FishMaster? {
        fishes.first { $0.id == id }
    }

    /// 餌IDからマスタを取得する。
    /// - Parameter id: 餌ID。
    /// - Returns: 見つかった餌マスタ。
    static func bait(id: String) -> BaitMaster? {
        baits.first { $0.id == id }
    }
}
