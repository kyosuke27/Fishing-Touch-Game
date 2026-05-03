import SwiftUI

/// 釣り結果を表示するオーバーレイ。
struct ResultOverlay: View {
    /// 表示対象の結果。
    let result: FishingResult
    /// 再挑戦アクション。
    let onRetry: () -> Void
    /// 閉じるアクション。
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                switch result {
                case let .success(catchRecord, isNewRecord, isNewFish):
                    successContent(
                        catchRecord: catchRecord,
                        isNewRecord: isNewRecord,
                        isNewFish: isNewFish
                    )

                case let .failure(target):
                    failureContent(target: target)
                }

                actionButtons
            }
            .frame(maxWidth: 340)
            .glassCard()
            .padding(20)
        }
    }

    /// 成功時の表示内容を返す。
    /// - Parameters:
    ///   - catchRecord: 釣果情報。
    ///   - isNewRecord: 新記録かどうか。
    ///   - isNewFish: 新規登録かどうか。
    /// - Returns: 成功時コンテンツ。
    @ViewBuilder
    private func successContent(
        catchRecord: CaughtFish,
        isNewRecord: Bool,
        isNewFish: Bool
    ) -> some View {
        let fish = GameMaster.fish(id: catchRecord.fishId) ?? GameMaster.fishes[0]

        VStack(spacing: 12) {
            Image("Fish")
                .resizable()
                .scaledToFit()
                .frame(height: 56)

            Text(catchRecord.fishName)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(GameTheme.mainBlue)
                .multilineTextAlignment(.center)

            RarityStars(rarity: catchRecord.rarity)

            FishBadge(fish: fish, size: 110)

            VStack(spacing: 10) {
                DetailRow(
                    title: String(localized: "fishing.result.weight"),
                    value: catchRecord.weight.formattedWeight
                )
                rewardRow(rewardCoin: catchRecord.rewardCoin)
                encyclopediaRow(isNewFish: isNewFish)

                if isNewRecord {
                    DetailRow(
                        title: String(localized: "fishing.result.record"),
                        value: String(localized: "fishing.result.best")
                    )
                }
            }
        }
    }

    /// 失敗時の表示内容を返す。
    /// - Parameter target: 対象魚。
    /// - Returns: 失敗時コンテンツ。
    @ViewBuilder
    private func failureContent(target: FishMaster) -> some View {
        VStack(spacing: 8) {
            Text(String(localized: "fishing.result.failure"))
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(GameTheme.warning)
        }
    }

    /// 獲得コイン行を返す。
    /// - Parameter rewardCoin: 獲得コイン数。
    /// - Returns: 獲得コイン表示行。
    @ViewBuilder
    private func rewardRow(rewardCoin: Int) -> some View {
        HStack {
            Text(String(localized: "fishing.result.reward"))
                .foregroundStyle(GameTheme.textSecondary)

            Spacer()

            HStack(spacing: 6) {
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                Text("\(rewardCoin)")
                    .fontWeight(.bold)
                    .foregroundStyle(GameTheme.textPrimary)
            }
        }
    }

    /// 図鑑状態行を返す。
    /// - Parameter isNewFish: 新規登録かどうか。
    /// - Returns: 図鑑状態表示行。
    @ViewBuilder
    private func encyclopediaRow(isNewFish: Bool) -> some View {
        HStack {
            Text(String(localized: "fishing.result.encyclopedia"))
                .foregroundStyle(GameTheme.textSecondary)

            Spacer()

            ZStack(alignment: .topLeading) {
                Text(isNewFish ? String(localized: "fishing.result.new") : "✅")
                    .fontWeight(.bold)
                    .foregroundStyle(GameTheme.textPrimary)
                    .padding(.top, isNewFish ? 8 : 0)

                if isNewFish {
                    Image("New")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .offset(x: -18, y: -10)
                }
            }
        }
    }

    /// 下部の画像ボタン群を返す。
    private var actionButtons: some View {
        VStack(spacing: 0) {
            imageButton(imageName: "RetryFishing", action: onRetry)
            imageButton(imageName: "HomeButton", action: onClose)
        }
    }

    /// 画像ボタンを返す。
    /// - Parameters:
    ///   - imageName: アセット名。
    ///   - action: 実行処理。
    /// - Returns: 画像ボタンView。
    @ViewBuilder
    private func imageButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
}
