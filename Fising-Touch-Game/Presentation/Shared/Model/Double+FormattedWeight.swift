import Foundation

/// 重量表示用の整形処理を提供する拡張。
extension Double {
    /// 重量表記へ整形した文字列。
    var formattedWeight: String {
        "\(self.formatted(.number.precision(.fractionLength(2))))kg"
    }
}
