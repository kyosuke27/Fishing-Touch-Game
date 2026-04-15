//
//  Fising_Touch_GameTests.swift
//  Fising-Touch-GameTests
//
//  Created by Codex on 2026/04/16.
//

import XCTest
@testable import Fising_Touch_Game

@MainActor
final class Fising_Touch_GameTests: XCTestCase {
    func testPurchaseBaitConsumesCoinAndAddsOwnership() {
        let repository = InMemoryRepository(data: GameMaster.initialData)
        let store = AppGameStore(repository: repository)
        let premiumBait = try! XCTUnwrap(GameMaster.bait(id: "premium_bait"))

        let purchased = store.purchaseBait(premiumBait)

        XCTAssertTrue(purchased)
        XCTAssertTrue(store.isOwned(baitId: premiumBait.id))
        XCTAssertEqual(store.userData.coin, GameMaster.initialData.coin - premiumBait.price)
    }

    func testRegisterCatchUnlocksEncyclopediaAndStoresHistory() {
        let repository = InMemoryRepository(data: GameMaster.initialData)
        let store = AppGameStore(repository: repository)
        let caughtFish = CaughtFish(
            id: UUID().uuidString,
            fishId: "aji",
            fishName: "アジ",
            rarity: 2,
            weight: 0.8,
            rewardCoin: 100,
            caughtAt: Date(timeIntervalSince1970: 1_000)
        )

        let result = store.registerCatch(caughtFish)
        let entry = store.encyclopediaEntry(for: "aji")

        XCTAssertTrue(result.isNewFish)
        XCTAssertTrue(result.isNewRecord)
        XCTAssertEqual(store.userData.catchHistory.first?.fishId, "aji")
        XCTAssertEqual(store.userData.coin, GameMaster.initialData.coin + 100)
        XCTAssertEqual(entry?.caughtCount, 1)
        XCTAssertEqual(entry?.maxWeight, 0.8)
        XCTAssertTrue(entry?.isUnlocked == true)
    }

    func testSelectingOwnedBaitUpdatesCurrentBait() {
        var initial = GameMaster.initialData
        initial.ownedBaitIds.append("premium_bait")
        let repository = InMemoryRepository(data: initial)
        let store = AppGameStore(repository: repository)
        let premiumBait = try! XCTUnwrap(GameMaster.bait(id: "premium_bait"))

        store.selectBait(premiumBait)

        XCTAssertEqual(store.selectedBait.id, "premium_bait")
    }
}

private final class InMemoryRepository: UserGameDataRepositoryProtocol {
    private var storedData: UserGameData

    init(data: UserGameData) {
        self.storedData = data
    }

    func load() throws -> UserGameData {
        storedData
    }

    func save(_ data: UserGameData) throws {
        storedData = data
    }
}
