import SwiftUI

/// 魚アイコンを丸バッジで表現する共通View。
struct FishBadge: View {
    /// 表示対象の魚。
    let fish: FishMaster
    /// バッジサイズ。
    let size: CGFloat
    /// 魚画像を秘匿表示にするか。
    let isHidden: Bool

    /// FishBadgeを生成する。
    /// - Parameters:
    ///   - fish: 表示対象の魚。
    ///   - size: バッジサイズ。
    ///   - isHidden: 魚画像を秘匿表示にするか。
    init(fish: FishMaster, size: CGFloat, isHidden: Bool = false) {
        self.fish = fish
        self.size = size
        self.isHidden = isHidden
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, rarityColor.opacity(0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)

            Image(isHidden ? "SecretFish" : fish.displayImageName)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.74, height: size * 0.74)
        }
        .shadow(color: rarityColor.opacity(0.22), radius: 12, x: 0, y: 8)
    }

    /// レアリティに応じた色を返す。
    private var rarityColor: Color {
        switch fish.rarity {
        case 5:
            GameTheme.warning

        case 4:
            GameTheme.accentYellow

        case 3:
            GameTheme.subGreen

        case 2:
            GameTheme.mainBlue.opacity(0.85)

        case 1:
            GameTheme.subGreen

        default:
            GameTheme.mainBlue
        }
    }
}

/// 画面表示用の画像名を返す拡張。
extension FishMaster {
    /// 魚画像アセット名。
    var displayImageName: String {
        switch id {
        case "medaka":
            "Medaka"

        case "isaki":
            "Isaki"

        case "kanpachi":
            "Kanpati"

        case "tai":
            "Tai"
            
        case "aji":
            "Azi"

        case "secret":
            "SecretFish"

        default:
            "Fish"
        }
    }
}
