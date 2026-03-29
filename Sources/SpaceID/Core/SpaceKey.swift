/// Stable identity for a Space across sessions.
/// Keyed by display UUID × position, since Space UUIDs are regenerated each login.
struct SpaceKey: Codable, Hashable {
    let displayUUID: String
    let spaceIndex: Int  // 0-based position in CGSCopyManagedDisplaySpaces "Spaces" array

    var storageKey: String { "\(displayUUID):\(spaceIndex)" }
}
