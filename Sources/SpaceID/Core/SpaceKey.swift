/// Identity for a Space within a session.
/// The per-space "uuid" from CGSCopyManagedDisplaySpaces is often stable across reboots
/// but can change (e.g. after a space is deleted and recreated, or on some macOS versions).
/// spaceIndex is always stable as long as the user does not reorder spaces.
/// SpaceStore uses both as keys: UUID primary, index as reboot fallback.
struct SpaceKey: Codable, Hashable {
    let displayUUID: String
    let spaceUUID: String  // per-space UUID from CGSCopyManagedDisplaySpaces "Spaces" array
    let spaceIndex: Int    // 0-based position on the display

    var storageKey: String { "\(displayUUID):\(spaceUUID)" }

    // Positional fallback key — stable across reboots that regenerate spaceUUID.
    var indexStorageKey: String { "\(displayUUID):\(spaceIndex)" }
}
