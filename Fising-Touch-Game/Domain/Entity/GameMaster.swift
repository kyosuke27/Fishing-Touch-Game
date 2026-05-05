import Foundation

/// ゲーム内で固定のマスタデータを提供する定義群。
enum GameMaster {
    /// 魚マスタ一覧。
    static let fishes: [FishMaster] = [
        FishMaster(
            id: "medaka",
            name: "メダカ",
            rarity: 1,
            description: "小さく身近な魚。序盤でよく釣れる基本枠。",
            requiredHits: 1,
            hitZoneWidth: 0.30,
            barSpeed: 1.8,
            minWeight: 0.1,
            maxWeight: 0.3,
            rewardCoin: 50,
            assetName: "fish"
        ),
        FishMaster(
            id: "funa",
            name: "フナ",
            rarity: 1,
            description: "淡水でおなじみの定番魚。序盤向けで狙いやすい。",
            requiredHits: 1,
            hitZoneWidth: 0.28,
            barSpeed: 1.7,
            minWeight: 0.3,
            maxWeight: 1.2,
            rewardCoin: 60,
            assetName: "fish"
        ),
        FishMaster(
            id: "dojo",
            name: "どじょう",
            rarity: 2,
            description: "フナより少しクセがあり、場所を選んで現れやすい魚。",
            requiredHits: 2,
            hitZoneWidth: 0.24,
            barSpeed: 1.5,
            minWeight: 0.1,
            maxWeight: 0.5,
            rewardCoin: 80,
            assetName: "fish"
        ),
        FishMaster(
            id: "kisu",
            name: "キス",
            rarity: 2,
            description: "海釣りの定番。序盤から中盤で狙いやすい軽快な魚。",
            requiredHits: 2,
            hitZoneWidth: 0.22,
            barSpeed: 1.45,
            minWeight: 0.2,
            maxWeight: 0.8,
            rewardCoin: 90,
            assetName: "fish.fill"
        ),
        FishMaster(
            id: "aji",
            name: "アジ",
            rarity: 2,
            description: "よく釣れる魚だが、食用魚として少し嬉しい定番枠。",
            requiredHits: 3,
            hitZoneWidth: 0.20,
            barSpeed: 1.3,
            minWeight: 0.3,
            maxWeight: 1.0,
            rewardCoin: 100,
            assetName: "fish.fill"
        ),
        FishMaster(
            id: "isaki",
            name: "イサキ",
            rarity: 3,
            description: "アジやキスより少し上位に位置する、味も見た目も良い海魚。",
            requiredHits: 4,
            hitZoneWidth: 0.17,
            barSpeed: 1.15,
            minWeight: 0.8,
            maxWeight: 2.5,
            rewardCoin: 150,
            assetName: "fish.fill"
        ),
        FishMaster(
            id: "suzuki",
            name: "スズキ",
            rarity: 3,
            description: "サイズ感があり、釣れた満足感を得やすい魚。",
            requiredHits: 4,
            hitZoneWidth: 0.16,
            barSpeed: 1.1,
            minWeight: 1.5,
            maxWeight: 4.5,
            rewardCoin: 170,
            assetName: "fish.circle.fill"
        ),
        FishMaster(
            id: "tai",
            name: "タイ",
            rarity: 4,
            description: "縁起が良く見た目も豪華。報酬感が強いスーパーレア魚。",
            requiredHits: 5,
            hitZoneWidth: 0.12,
            barSpeed: 0.95,
            minWeight: 2.0,
            maxWeight: 5.0,
            rewardCoin: 260,
            assetName: "fish.circle.fill"
        ),
        FishMaster(
            id: "kanpachi",
            name: "カンパチ",
            rarity: 4,
            description: "大型魚らしい迫力と高級魚感を併せ持つスーパーレア。",
            requiredHits: 5,
            hitZoneWidth: 0.11,
            barSpeed: 0.9,
            minWeight: 3.0,
            maxWeight: 8.0,
            rewardCoin: 300,
            assetName: "fish.circle.fill"
        ),
        FishMaster(
            id: "maguro",
            name: "マグロ",
            rarity: 5,
            description: "大物枠として圧倒的な存在感を持つ激レア魚。",
            requiredHits: 6,
            hitZoneWidth: 0.09,
            barSpeed: 0.8,
            minWeight: 20.0,
            maxWeight: 80.0,
            rewardCoin: 500,
            assetName: "fish.circle.fill"
        ),
        FishMaster(
            id: "same",
            name: "さめ",
            rarity: 5,
            description: "通常魚とは違う特別感を持つ、伝説級の激レア魚。",
            requiredHits: 7,
            hitZoneWidth: 0.08,
            barSpeed: 0.75,
            minWeight: 30.0,
            maxWeight: 120.0,
            rewardCoin: 650,
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
            rarityWeights: [
                "medaka": 34, "funa": 22, "dojo": 11, "kisu": 9, "aji": 9,
                "isaki": 6, "suzuki": 4, "tai": 3, "kanpachi": 2, "maguro": 1, "same": 0
            ],
            imageName: "Aoisome"
        ),
        BaitMaster(
            id: "premium_bait",
            name: "えび",
            description: "扱いやすく、レアな魚も狙いやすい定番の高級餌。",
            price: 300,
            rarity: 4,
            rarityWeights: [
                "medaka": 12, "funa": 6, "dojo": 9, "kisu": 10, "aji": 13,
                "isaki": 14, "suzuki": 12, "tai": 11, "kanpachi": 7, "maguro": 4, "same": 2
            ],
            imageName: "Ebi"
        ),
        BaitMaster(
            id: "okiami_bait",
            name: "オキアミ",
            description: "小型から中型まで幅広く寄せられる万能餌。",
            price: 100,
            rarity: 2,
            rarityWeights: [
                "medaka": 25, "funa": 16, "dojo": 11, "kisu": 11, "aji": 11,
                "isaki": 8, "suzuki": 6, "tai": 5, "kanpachi": 4, "maguro": 2, "same": 1
            ],
            imageName: "Okiami"
        ),
        BaitMaster(
            id: "kibinago_bait",
            name: "キビナゴ",
            description: "中型以上を狙いやすくなるバランス型の餌。",
            price: 200,
            rarity: 3,
            rarityWeights: [
                "medaka": 16, "funa": 9, "dojo": 9, "kisu": 11, "aji": 12,
                "isaki": 12, "suzuki": 10, "tai": 8, "kanpachi": 7, "maguro": 4, "same": 2
            ],
            imageName: "Kibinago"
        ),
        BaitMaster(
            id: "aji_bait",
            name: "アジ",
            description: "大型魚を強く意識した高級な活き餌。",
            price: 500,
            rarity: 5,
            rarityWeights: [
                "medaka": 4, "funa": 2, "dojo": 4, "kisu": 6, "aji": 8,
                "isaki": 12, "suzuki": 14, "tai": 16, "kanpachi": 14, "maguro": 12, "same": 10
            ],
            imageName: "IkiAzi"
        ),
        BaitMaster(
            id: "ika_kirimi_bait",
            name: "イカの切り身",
            description: "匂いで魚を寄せやすく、大物狙いにも向く餌。",
            price: 350,
            rarity: 4,
            rarityWeights: [
                "medaka": 7, "funa": 4, "dojo": 6, "kisu": 8, "aji": 10,
                "isaki": 12, "suzuki": 14, "tai": 14, "kanpachi": 12, "maguro": 10, "same": 6
            ],
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
