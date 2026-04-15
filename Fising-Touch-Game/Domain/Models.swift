//
//  Models.swift
//  Fising-Touch-Game
//
//  Created by Codex on 2026/04/16.
//

import Foundation

struct FishMaster: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let rarity: Int
    let description: String
    let requiredHits: Int
    let hitZoneWidth: Double
    let barSpeed: Double
    let minWeight: Double
    let maxWeight: Double
    let rewardCoin: Int
    let assetName: String
}

struct BaitMaster: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Int
    let rarityWeights: [String: Int]
    let assetName: String
}

struct CaughtFish: Codable, Identifiable, Hashable {
    let id: String
    let fishId: String
    let fishName: String
    let rarity: Int
    let weight: Double
    let rewardCoin: Int
    let caughtAt: Date
}

struct EncyclopediaEntry: Codable, Identifiable, Hashable {
    let id: String
    let fishId: String
    var isUnlocked: Bool
    var caughtCount: Int
    var maxWeight: Double?
    var firstCaughtAt: Date?
}

struct UserGameData: Codable, Equatable {
    var coin: Int
    var selectedBaitId: String
    var ownedBaitIds: [String]
    var catchHistory: [CaughtFish]
    var encyclopedia: [EncyclopediaEntry]
}

enum FishingResult: Equatable {
    case success(catch: CaughtFish, isNewRecord: Bool, isNewFish: Bool)
    case failure(target: FishMaster)
}
