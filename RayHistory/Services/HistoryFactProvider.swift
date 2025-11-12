import Foundation
import CoreLocation

@MainActor
final class HistoryFactProvider: ObservableObject {
    @Published private(set) var currentFact: HistoryFact?
    private var facts: [HistoryFact] = []
    private var factsByLocation: [String: [HistoryFact]] = [:]

    init(previewFacts: [HistoryFact] = []) {
        if previewFacts.isEmpty {
            loadInitialFacts()
        } else {
            facts = previewFacts
        }
    }

    func loadInitialFacts() {
        let shelbyvilleFacts = HistoryFact.previewFacts
        facts = shelbyvilleFacts

        let keyed = Dictionary(grouping: shelbyvilleFacts) { fact in
            locationKey(for: fact.coordinate)
        }
        factsByLocation.merge(keyed) { current, _ in current }
    }

    func updateFacts(for placemark: CLPlacemark) async {
        guard let location = placemark.location else { return }
        let key = locationKey(for: location.coordinate)

        if let locationFacts = factsByLocation[key], !locationFacts.isEmpty {
            presentRandomFact(from: locationFacts)
            return
        }

        if isShelbyville(placemark: placemark) {
            factsByLocation[key] = facts
            presentRandomFact(from: facts)
        }
    }

    private func presentRandomFact(from facts: [HistoryFact]) {
        guard !facts.isEmpty else { return }
        currentFact = facts.randomElement()
    }

    private func locationKey(for coordinate: CLLocationCoordinate2D) -> String {
        let precision = 3
        let lat = (coordinate.latitude * pow(10.0, Double(precision))).rounded() / pow(10.0, Double(precision))
        let lon = (coordinate.longitude * pow(10.0, Double(precision))).rounded() / pow(10.0, Double(precision))
        return "\(lat),\(lon)"
    }

    private func isShelbyville(placemark: CLPlacemark) -> Bool {
        guard let locality = placemark.locality?.lowercased(),
              let state = placemark.administrativeArea?.lowercased() else {
            return false
        }

        return locality.contains("shelbyville") && state == "il"
    }
}
