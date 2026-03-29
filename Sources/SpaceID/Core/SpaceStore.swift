import Foundation
import Combine

/// Persists user-defined Space names in UserDefaults.
final class SpaceStore: ObservableObject {
    @Published private(set) var names: [String: String]

    private let defaultsKey = "spaceNames"

    init() {
        names = UserDefaults.standard.dictionary(forKey: "spaceNames") as? [String: String] ?? [:]
    }

    /// Returns the user-defined name, or a generated default ("Space N").
    func name(for key: SpaceKey) -> String {
        names[key.storageKey] ?? "Space \(key.spaceIndex + 1)"
    }

    /// Saves a name. Passing an empty string removes the custom name (reverts to default).
    func setName(_ name: String, for key: SpaceKey) {
        if name.isEmpty {
            names.removeValue(forKey: key.storageKey)
        } else {
            names[key.storageKey] = name
        }
        UserDefaults.standard.set(names, forKey: defaultsKey)
    }
}
