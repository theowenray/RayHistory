import Contacts
import CoreLocation
import MapKit

@MainActor
final class HistoryLocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentPlacemark: CLPlacemark?

    private let locationManager = CLLocationManager()
    private var previewCoordinate: CLLocationCoordinate2D?

    init(previewMode: Bool = false) {
        let status = CLLocationManager.authorizationStatus()
        self.authorizationStatus = status
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 25

        if previewMode {
            previewCoordinate = CLLocationCoordinate2D(latitude: 39.4067, longitude: -88.7901)
            currentPlacemark = previewPlacemark()
        }
    }

    func requestAuthorization() async {
        guard previewCoordinate == nil else { return }

        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    private func updatePlacemark(for location: CLLocation) {
        Task {
            let geocoder = CLGeocoder()
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                if let placemark = placemarks.first {
                    self.currentPlacemark = placemark
                }
            } catch {
                print("Reverse geocoding failed: \(error.localizedDescription)")
            }
        }
    }

    private func previewPlacemark() -> CLPlacemark? {
        guard let coordinate = previewCoordinate else { return nil }
        let address = [
            CNPostalAddressStreetKey: "301 E Main St",
            CNPostalAddressCityKey: "Shelbyville",
            CNPostalAddressStateKey: "IL",
            CNPostalAddressPostalCodeKey: "62565"
        ]
        return MKPlacemark(coordinate: coordinate, addressDictionary: address)
    }
}

extension HistoryLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updatePlacemark(for: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
