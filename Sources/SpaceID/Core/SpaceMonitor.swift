import AppKit
import Combine
import CGSBridge

/// Observes space-change notifications and publishes the current SpaceKey.
final class SpaceMonitor: ObservableObject {
    @Published private(set) var currentSpaceKey: SpaceKey?

    private var observer: Any?

    func start() {
        refresh()
        observer = NotificationCenter.default.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: NSWorkspace.shared,
            queue: .main
        ) { [weak self] _ in
            self?.refresh()
        }
    }

    /// Re-queries CGS and updates currentSpaceKey. Always called on main thread.
    private func refresh() {
        let conn = CGSMainConnectionID()
        guard let displays = CGSCopyManagedDisplaySpaces(conn) as? [[String: Any]] else { return }

        // Use the first display. For multi-display setups this is typically the
        // primary display; full multi-display support is a future improvement.
        for display in displays {
            guard
                let currentSpace = display["Current Space"] as? [String: Any],
                let currentID = currentSpace["id64"] as? Int,
                let spaces = display["Spaces"] as? [[String: Any]],
                let displayUUID = display["Display Identifier"] as? String
            else { continue }

            let index = spaces.firstIndex { ($0["id64"] as? Int) == currentID } ?? 0
            currentSpaceKey = SpaceKey(displayUUID: displayUUID, spaceIndex: index)
            return
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
