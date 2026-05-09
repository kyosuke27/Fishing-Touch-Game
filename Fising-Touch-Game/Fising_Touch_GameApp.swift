import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct Fising_Touch_GameApp: App {
    init() {
        MobileAds.shared.start()
        print("✅initial MobileAds")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    ATTrackingManager.requestTrackingAuthorization { status in
                        switch status {
                        case .notDetermined:
                            print("トラッキング許可の有無が未設定です")
                            
                        case .restricted:
                            print("トラッキングが制限されています")
                            
                        case .denied:
                            print("トラッキングが拒否されました")
                            
                        case .authorized:
                            print("トラッキングが許可されました")
                            
                        @unknown default:
                            print("不明な状態です")
                        }
                    }
                }
        }
    }
}
