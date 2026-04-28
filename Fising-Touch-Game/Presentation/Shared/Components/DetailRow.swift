import SwiftUI

/// ラベルと値の横並び表示を行う共通View。
struct DetailRow: View {
    /// 項目名。
    let title: String
    /// 項目値。
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(GameTheme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(GameTheme.textPrimary)
        }
    }
}
