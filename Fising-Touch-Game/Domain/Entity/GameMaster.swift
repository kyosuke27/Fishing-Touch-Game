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
            description: "無料で入手できる基本の餌。小型の魚を狙いやすい。",
            price: 0,
            rarity: 1,
            rarityWeights: ["medaka": 55, "aji": 35, "tai": 10],
            imageName: "Aoisome"
        ),
        BaitMaster(
            id: "premium_bait",
            name: "えび",
            description: "扱いやすく、レアな魚も狙いやすい定番の高級餌。",
            price: 300,
            rarity: 4,
            rarityWeights: ["medaka": 20, "aji": 35, "tai": 45],
            imageName: "Ebi"
        ),
        BaitMaster(
            id: "okiami_bait",
            name: "オキアミ",
            description: "小型から中型まで幅広く寄せられる万能餌。",
            price: 100,
            rarity: 2,
            rarityWeights: ["medaka": 45, "aji": 40, "tai": 15],
            imageName: "Okiami"
        ),
        BaitMaster(
            id: "kibinago_bait",
            name: "キビナゴ",
            description: "中型以上を狙いやすくなるバランス型の餌。",
            price: 200,
            rarity: 3,
            rarityWeights: ["medaka": 35, "aji": 40, "tai": 25],
            imageName: "Kibinago"
        ),
        BaitMaster(
            id: "aji_bait",
            name: "アジ",
            description: "大型魚を強く意識した高級な活き餌。",
            price: 500,
            rarity: 5,
            rarityWeights: ["medaka": 10, "aji": 25, "tai": 65],
            imageName: "IkiAzi"
        ),
        BaitMaster(
            id: "ika_kirimi_bait",
            name: "イカの切り身",
            description: "匂いで魚を寄せやすく、大物狙いにも向く餌。",
            price: 350,
            rarity: 4,
            rarityWeights: ["medaka": 18, "aji": 37, "tai": 45],
            imageName: "IkaKirimi"
        )
    ]

    /// 初期ユーザーデータ。
    static let initialData = UserGameData(
        coin: 500,
        selectedBaitId: "normal_bait",
        baitQuantities: ["normal_bait": 1],
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
