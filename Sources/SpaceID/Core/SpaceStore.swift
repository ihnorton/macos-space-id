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
    /// Tries the UUID-based key first (survives space reorders within a session),
    /// then falls back to the index-based key (survives reboots that regenerate UUIDs).
    /// When the index fallback is used, the UUID key is written so subsequent lookups are fast.
    func name(for key: SpaceKey) -> String {
        if let name = names[key.storageKey] {
            return name
        }
        if let name = names[key.indexStorageKey] {
            names[key.storageKey] = name
            UserDefaults.standard.set(names, forKey: defaultsKey)
            return name
        }
        return "Space \(key.spaceIndex + 1)"
    }

    /// Returns the stored name for a raw storage key, or nil if absent.
    func nameForStorageKey(_ key: String) -> String? {
        names[key]
    }

    /// Copies a stored name to a new raw storage key without removing the old one.
    /// Keeping the old (index-based) key as a fallback preserves resilience across reboots.
    func migrateKey(from oldKey: String, to newKey: String) {
        guard let name = names[oldKey], names[newKey] == nil else { return }
        names[newKey] = name
        UserDefaults.standard.set(names, forKey: defaultsKey)
    }

    /// Saves a name. Passing an empty string removes the custom name (reverts to default).
    /// Writes to both the UUID key and the index key so the name survives
    /// reboots that regenerate space UUIDs.
    func setName(_ name: String, for key: SpaceKey) {
        if name.isEmpty {
            names.removeValue(forKey: key.storageKey)
            names.removeValue(forKey: key.indexStorageKey)
        } else {
            names[key.storageKey] = name
            names[key.indexStorageKey] = name
        }
        UserDefaults.standard.set(names, forKey: defaultsKey)
    }
}
