import SwiftUI

/// ホームメニューで使う共通ボタン。
struct HomeMenuButton: View {
    /// 表示画像名。
    let imageName: String

    var body: some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 52)
        }
        .frame(maxWidth: .infinity)
    }
}
