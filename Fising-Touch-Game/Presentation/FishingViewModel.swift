//
//  FishingViewModel.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import Combine
import Foundation

@MainActor
final class FishingViewModel: ObservableObject {
    @Published private(set) var targetFish: FishMaster
    @Published private(set) var currentWeight: Double
    @Published private(set) var successCount = 0
    @Published private(set) var barPosition = 0.0
    @Published private(set) var hitZoneCenter = 0.5
    @Published private(set) var result: FishingResult?
    @Published private(set) var isRunning = true

    private let store: AppGameStore
    private var direction = 1.0

    init(store: AppGameStore) {
        self.store = store
        let fish = FishingViewModel.drawFish(using: store.selectedBait)
        self.targetFish = fish
        self.currentWeight = FishingViewModel.drawWeight(for: fish)
        self.hitZoneCenter = FishingViewModel.makeHitZoneCenter(width: fish.hitZoneWidth)
    }

    var selectedBait: BaitMaster {
        store.selectedBait
    }

    func update(deltaTime: TimeInterval) {
        guard isRunning else { return }

        let delta = deltaTime * targetFish.barSpeed * 0.35 * direction
        var nextPosition = barPosition + delta

        if nextPosition >= 1 {
            nextPosition = 1
            direction = -1
        } else if nextPosition <= 0 {
            nextPosition = 0
            direction = 1
        }

        barPosition = nextPosition
    }

    /// ヒット時のみ次ラウンドへ進み、必要回数に達したら即保存する。
    func tap() {
        guard isRunning else { return }

        let lowerBound = hitZoneCenter - (targetFish.hitZoneWidth / 2)
        let upperBound = hitZoneCenter + (targetFish.hitZoneWidth / 2)

        guard (lowerBound...upperBound).contains(barPosition) else {
            isRunning = false
            result = .failure(target: targetFish)
            return
        }

        successCount += 1

        guard successCount >= targetFish.requiredHits else {
            hitZoneCenter = Self.makeHitZoneCenter(width: targetFish.hitZoneWidth)
            return
        }

        let caughtFish = CaughtFish(
            id: UUID().uuidString,
            fishId: targetFish.id,
            fishName: targetFish.name,
            rarity: targetFish.rarity,
            weight: currentWeight,
            rewardCoin: targetFish.rewardCoin,
            caughtAt: Date()
        )

        let registerResult = store.registerCatch(caughtFish)
        isRunning = false
        result = .success(
            catch: caughtFish,
            isNewRecord: registerResult.isNewRecord,
            isNewFish: registerResult.isNewFish
        )
    }

    func restart() {
        let fish = Self.drawFish(using: store.selectedBait)
        targetFish = fish
        currentWeight = Self.drawWeight(for: fish)
        successCount = 0
        barPosition = 0
        hitZoneCenter = Self.makeHitZoneCenter(width: fish.hitZoneWidth)
        result = nil
        isRunning = true
        direction = 1
    }

    private static func drawFish(using bait: BaitMaster) -> FishMaster {
        let totalWeight = max(bait.rarityWeights.values.reduce(0, +), 1)
        let roll = Int.random(in: 0..<totalWeight)
        var cumulative = 0

        for fish in GameMaster.fishes {
            cumulative += bait.rarityWeights[fish.id] ?? 0
            if roll < cumulative {
                return fish
            }
        }

        return GameMaster.fishes[0]
    }

    private static func drawWeight(for fish: FishMaster) -> Double {
        let rawWeight = Double.random(in: fish.minWeight...fish.maxWeight)
        return (rawWeight * 100).rounded() / 100
    }

    private static func makeHitZoneCenter(width: Double) -> Double {
        let margin = max(width / 2, 0.08)
        return Double.random(in: margin...(1 - margin))
    }
}
