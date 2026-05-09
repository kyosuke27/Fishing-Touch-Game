import Foundation
import SwiftUI
import GoogleMobileAds

/// AdMobのバナー広告をSwiftUIで表示するためのUIViewRepresentable。
struct AdmobBannerView: UIViewRepresentable {
    /// SwiftUIで扱うUIKit側のView型。
    typealias UIViewType = BannerView
    /// 表示する広告サイズ。
    let adSize: AdSize

    /// バナーViewを生成する。
    /// - Parameter adSize: 表示する広告サイズ。
    init(_ adSize: AdSize) {
        self.adSize = adSize
    }

    /// UIKitのバナーViewを生成する。
    /// - Parameter context: SwiftUIのView生成コンテキスト。
    /// - Returns: 広告ロードを開始したBannerView。
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        let keys = Bundle.main.infoDictionary?["ApiKeys"] as? [String: Any]
        let key = keys?["BannerKey"] as? String ?? ""
        banner.adUnitID = key
        banner.load(Request())
        banner.delegate = context.coordinator
        return banner
    }

    /// SwiftUIの状態更新時にUIKitのバナーViewを更新する。
    /// - Parameters:
    ///   - uiView: 更新対象のBannerView。
    ///   - context: SwiftUIの更新コンテキスト。
    func updateUIView(_ uiView: BannerView, context: Context) {}

    /// バナー広告イベントを受け取るCoordinatorを生成する。
    /// - Returns: バナー広告イベント用Coordinator。
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }

    /// バナー広告のライフサイクルイベントを受け取るCoordinator。
    class BannerCoordinator: NSObject, BannerViewDelegate {
        /// 親のSwiftUIバナーView。
        let parent: AdmobBannerView

        /// Coordinatorを生成する。
        /// - Parameter parent: 親のSwiftUIバナーView。
        init(_ parent: AdmobBannerView) {
          self.parent = parent
        }

        /// バナー広告の受信成功時に呼ばれる。
        /// - Parameter bannerView: 広告を受信したBannerView。
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
          print("AdMob banner received")
        }

        /// バナー広告の受信失敗時に呼ばれる。
        /// - Parameters:
        ///   - bannerView: 広告ロードに失敗したBannerView。
        ///   - error: 失敗理由。
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
          print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
      }
}

/// 画面下部固定に適した標準バナー広告View。
struct AdmobAnchoredBannerView: View {
    /// 親画面の横幅。
    let width: CGFloat

    /// Viewを生成する。
    /// - Parameter width: 親画面の横幅。
    init(width: CGFloat) {
        self.width = width
    }

    var body: some View {
        let adSize = AdSizeBanner

        AdmobBannerView(adSize)
            .frame(width: adSize.size.width, height: adSize.size.height)
            // バナーより少し大きい薄黒い背景で、広告の視認性を確保する。
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))
    }
}
