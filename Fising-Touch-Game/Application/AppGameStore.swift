//
//  AppGameStore.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import Combine
import Foundation

@MainActor
final class AppGameStore: ObservableObject {
    @Published private(set) var userData: UserGameData
    @Published private(set) var lastErrorMessage: String?

    private let repository: UserGameDataRepositoryProtocol

    init(repository: UserGameDataRepositoryProtocol? = nil) {
        self.repository = repository ?? UserGameDataRepository()

        do {
            self.userData = try self.repository.load()
        } catch {
            self.userData = GameMaster.initialData
            self.lastErrorMessage = "保存データの読み込みに失敗したため初期データで開始しました。"
            try? self.repository.save(self.userData)
        }
    }

    var selectedBait: BaitMaster {
        GameMaster.bait(id: userData.selectedBaitId) ?? GameMaster.baits[0]
    }

    var unlockedFishCount: Int {
        userData.encyclopedia.filter(\.isUnlocked).count
    }

    func isOwned(baitId: String) -> Bool {
        userData.ownedBaitIds.contains(baitId)
    }

    /// 購入後すぐに永続化して所持状態を保つ。
    func purchaseBait(_ bait: BaitMaster) -> Bool {
        guard !isOwned(baitId: bait.id), userData.coin >= bait.price else {
            return false
        }

        userData.coin -= bait.price
        userData.ownedBaitIds.append(bait.id)
        persist()
        return true
    }

    func selectBait(_ bait: BaitMaster) {
        guard isOwned(baitId: bait.id) else { return }
        userData.selectedBaitId = bait.id
        persist()
    }

    /// 釣果履歴と図鑑を同時に更新して表示内容を一貫させる。
    func registerCatch(_ caughtFish: CaughtFish) -> (isNewFish: Bool, isNewRecord: Bool) {
        userData.coin += caughtFish.rewardCoin
        userData.catchHistory.insert(caughtFish, at: 0)

        var isNewFish = false
        var isNewRecord = false

        if let index = userData.encyclopedia.firstIndex(where: { $0.fishId == caughtFish.fishId }) {
            var entry = userData.encyclopedia[index]
            isNewFish = !entry.isUnlocked
            entry.isUnlocked = true
            entry.caughtCount += 1

            if let maxWeight = entry.maxWeight {
                if caughtFish.weight > maxWeight {
                    entry.maxWeight = caughtFish.weight
                    isNewRecord = true
                }
            } else {
                entry.maxWeight = caughtFish.weight
                entry.firstCaughtAt = caughtFish.caughtAt
                isNewRecord = true
            }

            if entry.firstCaughtAt == nil {
                entry.firstCaughtAt = caughtFish.caughtAt
            }

            userData.encyclopedia[index] = entry
        }

        persist()
        return (isNewFish, isNewRecord)
    }

    func fishMaster(for fishId: String) -> FishMaster? {
        GameMaster.fish(id: fishId)
    }

    func encyclopediaEntry(for fishId: String) -> EncyclopediaEntry? {
        userData.encyclopedia.first { $0.fishId == fishId }
    }

    private func persist() {
        do {
            try repository.save(userData)
            lastErrorMessage = nil
        } catch {
            lastErrorMessage = "保存に失敗しました。"
        }
    }
}
