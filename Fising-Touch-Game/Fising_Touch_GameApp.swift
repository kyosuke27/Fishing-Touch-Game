import SwiftUI
import GoogleMobileAds

@main
struct Fising_Touch_GameApp: App {
    init() {
        MobileAds.shared.start()
        print("✅initial MobileAds")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
