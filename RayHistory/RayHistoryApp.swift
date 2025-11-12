import SwiftUI

@main
struct RayHistoryApp: App {
    @StateObject private var locationManager = HistoryLocationManager()
    @StateObject private var factProvider = HistoryFactProvider()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(factProvider)
        }
    }
}
