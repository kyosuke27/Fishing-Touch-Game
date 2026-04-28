import SwiftUI

/// タイトルと数値を並べる共通カード。
struct CounterCard: View {
    /// 項目名。
    let title: String
    /// 表示値。
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(GameTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(GameTheme.textPrimary)
        }
        .glassCard()
    }
}
