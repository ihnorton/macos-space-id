/// Stable identity for a Space across sessions.
/// Keyed by display UUID × per-space UUID. The per-space "uuid" field in
/// CGSCopyManagedDisplaySpaces is stable across logins (unlike the session-local "id64").
struct SpaceKey: Codable, Hashable {
    let displayUUID: String
    let spaceUUID: String  // per-space UUID from CGSCopyManagedDisplaySpaces "Spaces" array
    let spaceIndex: Int    // 0-based position, used only for the default label "Space N"

    var storageKey: String { "\(displayUUID):\(spaceUUID)" }
}
