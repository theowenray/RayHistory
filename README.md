# RayHistory

RayHistory is an iOS application that turns your surroundings into a history tour. The app highlights notable stories tied to the location you are standing in so you can learn about the past while exploring the present. The initial release focuses on downtown Shelbyville, Illinois and the places Abraham Lincoln once visited.

## Project structure

- `RayHistory.xcodeproj/` – Xcode project used to build the app.
- `RayHistory/` – SwiftUI source files, assets, and configuration.
  - `Models/` – Data structures that describe a historical fact.
  - `Services/` – Location handling and fact lookup helpers.
  - `Views/` – SwiftUI views, including the map overlay card.

## Features

- SwiftUI interface with a full-screen interactive map.
- Location manager that requests permission and reverse-geocodes the user’s position.
- Local fact provider seeded with Shelbyville, IL landmarks and Lincoln-era trivia.
- Elegant cards that surface a random fact relevant to the user’s current area.

## Requirements

- Xcode 15 or newer
- iOS 17.0 target or later

## Running the app

1. Open `RayHistory.xcodeproj` in Xcode.
2. Select the *RayHistory* target and choose an iOS simulator (or a connected device).
3. Build and run. When prompted, allow location access so the app can determine where you are.

## Extending the fact library

Historical facts are currently provided by `HistoryFactProvider`. To add new places:

1. Create additional `HistoryFact` entries in `HistoryFact.previewFacts` or fetch them from a remote source.
2. Use the `factsByLocation` dictionary to scope facts to a region or placemark.
3. Provide a `sourceURL` so curious users can keep learning.
