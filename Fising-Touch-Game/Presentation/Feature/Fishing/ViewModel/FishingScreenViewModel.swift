import Combine
import Foundation

/// 釣り画面の入力処理と状態管理を行うViewModel。
@MainActor
final class FishingScreenViewModel: ObservableObject {
    /// 釣り画面の表示状態。
    @Published private(set) var state: FishingState

    /// 共通ストア。
    private let store: GameSessionStore
    /// バー移動方向。
    private var direction = 1.0

    /// ViewModelを生成する。
    /// - Parameter store: 共通ストア。
    init(store: GameSessionStore) {
        self.store = store
        let fish = Self.drawFish(using: store.selectedBait)
        self.state = FishingState(
            targetFish: fish,
            currentWeight: Self.drawWeight(for: fish),
            successCount: 0,
            barPosition: 0,
            // Hitエリアの中心
            hitZoneCenter: Self.makeHitZoneCenter(width: fish.hitZoneWidth),
            result: nil,
            isRunning: true
        )
    }

    /// 1フレーム分の位置更新を行う。
    /// - Parameter deltaTime: 前フレームからの経過秒数。
    func update(deltaTime: TimeInterval) {
        guard state.isRunning else { return }

        // 変化値
        let delta = deltaTime * state.targetFish.barSpeed * 0.35 * direction
        var nextPosition = state.barPosition + delta

        if nextPosition >= 1 {
            nextPosition = 1
            direction = -1
        } else if nextPosition <= 0 {
            nextPosition = 0
            direction = 1
        }

        state.barPosition = nextPosition
    }

    /// タップ判定を行い、成功時は釣果を登録する。
    func tap() {
        guard state.isRunning else { return }

        // 左端
        let lowerBound = state.hitZoneCenter - (state.targetFish.hitZoneWidth / 2)
        // 右端
        let upperBound = state.hitZoneCenter + (state.targetFish.hitZoneWidth / 2)

        // barのポジション
        guard (lowerBound...upperBound).contains(state.barPosition) else {
            state.isRunning = false
            state.result = .failure(target: state.targetFish)
            return
        }

        state.successCount += 1

        // 成功判定
        guard state.successCount >= state.targetFish.requiredHits else {
            state.hitZoneCenter = Self.makeHitZoneCenter(width: state.targetFish.hitZoneWidth)
            return
        }

        let caughtFish = CaughtFish(
            id: UUID().uuidString,
            fishId: state.targetFish.id,
            fishName: state.targetFish.name,
            rarity: state.targetFish.rarity,
            weight: state.currentWeight,
            rewardCoin: state.targetFish.rewardCoin,
            caughtAt: Date()
        )

        let registerResult = store.registerCatch(caughtFish)
        state.isRunning = false
        state.result = .success(
            catch: caughtFish,
            isNewRecord: registerResult.isNewRecord,
            isNewFish: registerResult.isNewFish
        )
    }

    /// 新しい釣りラウンドを開始する。
    func restart() {
        let fish = Self.drawFish(using: store.selectedBait)
        state = FishingState(
            targetFish: fish,
            currentWeight: Self.drawWeight(for: fish),
            successCount: 0,
            barPosition: 0,
            hitZoneCenter: Self.makeHitZoneCenter(width: fish.hitZoneWidth),
            result: nil,
            isRunning: true
        )
        direction = 1
    }

    /// 餌に応じて魚を抽選する。
    /// - Parameter bait: 使用中の餌。
    /// - Returns: 抽選結果の魚。
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

    /// 魚の重量を抽選する。
    /// - Parameter fish: 抽選対象の魚。
    /// - Returns: 小数第2位まで丸めた重量。
    private static func drawWeight(for fish: FishMaster) -> Double {
        let rawWeight = Double.random(in: fish.minWeight...fish.maxWeight)
        return (rawWeight * 100).rounded() / 100
    }

    /// ヒットエリア中心位置を生成する。
    /// - Parameter width: ヒットエリア幅。
    /// - Returns: 0〜1の中心位置。
    private static func makeHitZoneCenter(width: Double) -> Double {
        let margin = max(width / 2, 0.08)
        return Double.random(in: margin...(1 - margin))
    }
}
