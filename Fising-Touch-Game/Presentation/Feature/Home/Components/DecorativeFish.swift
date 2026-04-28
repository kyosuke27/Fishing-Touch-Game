import SwiftUI

/// ホーム画面の飾り魚アイコン。
struct DecorativeFish: View {
    /// 表示アイコン名。
    let systemName: String
    /// 表示色。
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(color)
            .padding(14)
            .background(.white.opacity(0.72), in: Circle())
    }
}
