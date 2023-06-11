# weatherapp

- SwiftUI based app
- Swift concurrent networking, generic to any Decodable response
- Combine based publishing Timer
- @Published + ObservableObject to update UI

Improvements:
- scalable/dynamic requesting or prefetching (in this timer based setup)

- Environment/App state manager
- Coordinators to evaluate app state and decide UX flow
- ViewModels to formats raw data into user facing formats

Features (in a real world setup):
- Network error handling, 401 etc.
- Use real user location
- Settings for customization of the UI

