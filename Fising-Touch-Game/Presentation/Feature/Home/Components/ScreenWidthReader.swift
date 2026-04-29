import SwiftUI
import UIKit

/// 現在のWindowに紐づく画面幅を監視するView。
struct ScreenWidthReader: UIViewRepresentable {
    /// 取得した画面幅。
    @Binding var width: CGFloat

    /// 監視用UIViewを生成する。
    /// - Parameter context: 表示コンテキスト。
    /// - Returns: 監視用UIView。
    func makeUIView(context: Context) -> ScreenWidthObserverView {
        let view = ScreenWidthObserverView()
        view.onUpdateWidth = { newWidth in
            DispatchQueue.main.async {
                width = newWidth
            }
        }
        return view
    }

    /// 監視用UIViewを更新する。
    /// - Parameters:
    ///   - uiView: 対象UIView。
    ///   - context: 表示コンテキスト。
    func updateUIView(_ uiView: ScreenWidthObserverView, context: Context) {
        uiView.onUpdateWidth = { newWidth in
            DispatchQueue.main.async {
                width = newWidth
            }
        }
        uiView.updateWidthIfNeeded()
    }
}

/// WindowSceneに紐づくScreen幅を取得するUIView。
final class ScreenWidthObserverView: UIView {
    /// 幅更新時の通知。
    var onUpdateWidth: ((CGFloat) -> Void)?
    /// 最後に通知した幅。
    private var lastReportedWidth: CGFloat = 0

    /// Windowへ追加されたタイミングで幅を更新する。
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateWidthIfNeeded()
    }

    /// レイアウト更新時に幅を更新する。
    override func layoutSubviews() {
        super.layoutSubviews()
        updateWidthIfNeeded()
    }

    /// 現在のScreen幅を通知する。
    func updateWidthIfNeeded() {
        let screenWidth = window?.windowScene?.screen.bounds.width ?? bounds.width
        guard screenWidth > 0 else { return }
        guard screenWidth != lastReportedWidth else { return }
        lastReportedWidth = screenWidth
        onUpdateWidth?(screenWidth)
    }
}
