import Foundation
import Combine
import GoogleMobileAds
import UIKit

/// インタースティシャル広告のロードと表示を管理するViewModel。
@MainActor
final class InterstitialViewModel: NSObject, ObservableObject {
    /// ロード済みのインタースティシャル広告。
    private var interstitialAd: InterstitialAd?
    /// 広告表示完了後に実行する処理。
    private var pendingCompletion: (() -> Void)?
    /// 広告ロード中かどうか。
    private var isLoading = false

    /// インタースティシャル広告を事前ロードする。
    func load() {
        guard !isLoading, interstitialAd == nil else { return }

        isLoading = true
        Task {
            do {
                let keys = Bundle.main.infoDictionary?["ApiKeys"] as? [String: Any]
                let key = keys?["InterstitialKey"] as? String ?? ""
                let ad = try await InterstitialAd.load(with: key, request: Request())
                ad.fullScreenContentDelegate = self
                interstitialAd = ad
            } catch {
                print("FAILED TO LOAD INTERSTITIAL AD: \(error.localizedDescription)")
            }

            isLoading = false
        }
    }

    /// ロード済み広告があれば表示し、なければ処理をそのまま続行する。
    /// - Parameter completion: 広告を閉じた後、または広告未ロード時に実行する処理。
    func presentIfAvailable(completion: @escaping () -> Void) {
        guard let interstitialAd else {
            completion()
            load()
            return
        }

        do {
            try interstitialAd.canPresent(from: nil)
            pendingCompletion = completion
            interstitialAd.present(from: nil)
        } catch {
            print("FAILED TO PRESENT INTERSTITIAL AD: \(error.localizedDescription)")
            self.interstitialAd = nil
            completion()
            load()
        }
    }

    /// 保留中の処理を実行し、次回表示用の広告をロードする。
    private func completePresentation() {
        let completion = pendingCompletion
        pendingCompletion = nil
        interstitialAd = nil
        completion?()
        load()
    }
}

extension InterstitialViewModel: FullScreenContentDelegate {
    /// 広告表示に失敗した時に呼ばれる。
    /// - Parameters:
    ///   - ad: 表示に失敗した広告。
    ///   - error: 失敗理由。
    func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("FAILED TO PRESENT FULL SCREEN CONTENT: \(error.localizedDescription)")
        completePresentation()
    }

    /// 広告が閉じられた時に呼ばれる。
    /// - Parameter ad: 閉じられた広告。
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        completePresentation()
    }
}
