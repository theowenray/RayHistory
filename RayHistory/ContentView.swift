import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var locationManager: HistoryLocationManager
    @EnvironmentObject private var factProvider: HistoryFactProvider
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition, interactionModes: .all, scope: .userLocation)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                .mapStyle(.standard(elevation: .realistic))
                .ignoresSafeArea()
                .task {
                    await locationManager.requestAuthorization()
                }

            VStack(spacing: 12) {
                if let fact = factProvider.currentFact {
                    HistoryFactCardView(fact: fact)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal)
                } else {
                    PlaceholderCard()
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 32)
        }
        .onReceive(locationManager.$currentPlacemark.compactMap { $0 }) { placemark in
            Task {
                await factProvider.updateFacts(for: placemark)
            }
        }
        .onAppear {
            factProvider.loadInitialFacts()
        }
    }
}

private struct PlaceholderCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Explore local history")
                .font(.headline)
            Text("Move around the map or tap the location button to discover historical facts about where you are.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.3))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryLocationManager(previewMode: true))
        .environmentObject(HistoryFactProvider(previewFacts: HistoryFact.previewFacts))
}
