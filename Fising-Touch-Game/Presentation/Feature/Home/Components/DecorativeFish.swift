import SwiftUI

/// ホーム画面の飾り魚アイコン。
struct DecorativeFish: View {
    /// 表示画像名。
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 52, height: 52)
            .padding(12)
            .shadow(color: GameTheme.mainBlue.opacity(0.14), radius: 8, x: 0, y: 5)
    }
}
