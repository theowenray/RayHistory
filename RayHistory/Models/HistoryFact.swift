import Foundation
import CoreLocation

struct HistoryFact: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let date: String?
    let coordinate: CLLocationCoordinate2D
    let sourceURL: URL?

    init(id: UUID = UUID(), title: String, description: String, date: String? = nil, coordinate: CLLocationCoordinate2D, sourceURL: URL? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.coordinate = coordinate
        self.sourceURL = sourceURL
    }
}

extension HistoryFact {
    static let previewFacts: [HistoryFact] = [
        HistoryFact(
            title: "Shelby County Courthouse",
            description: "Abraham Lincoln practiced law in the Shelby County Circuit Court during his years on the 8th Judicial Circuit.",
            date: "1840s",
            coordinate: CLLocationCoordinate2D(latitude: 39.4067, longitude: -88.7901),
            sourceURL: URL(string: "https://www.lincolncircuit.org/communities/shelbyville")
        ),
        HistoryFact(
            title: "Kaskaskia River Ford",
            description: "Early settlers crossed the Kaskaskia River near this location, helping Shelbyville grow as a regional hub in central Illinois.",
            date: "1820s",
            coordinate: CLLocationCoordinate2D(latitude: 39.4054, longitude: -88.7908)
        )
    ]
}
