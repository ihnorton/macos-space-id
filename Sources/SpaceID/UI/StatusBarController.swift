import AppKit
import SwiftUI
import Combine

/// Owns the NSStatusItem and manages the rename popover.
final class StatusBarController {
    private let statusItem: NSStatusItem
    private let monitor: SpaceMonitor
    private let store: SpaceStore
    private var popover: NSPopover?
    private var popoverCloseObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    init(monitor: SpaceMonitor, store: SpaceStore) {
        self.monitor = monitor
        self.store = store
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.title = "•"
            button.action = #selector(handleClick)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Update title whenever the current space or its name changes.
        monitor.$currentSpaceKey
            .combineLatest(store.$names)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] key, _ in
                guard let self, let key else { return }
                self.statusItem.button?.title = self.store.name(for: key)
            }
            .store(in: &cancellables)
    }

    @objc private func handleClick() {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            showQuitMenu()
        } else {
            if let p = popover, p.isShown {
                p.performClose(nil)
            } else {
                showPopover()
            }
        }
    }

    private func showQuitMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit SpaceID", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        // Temporarily assign the menu so the status item can pop it, then clear it
        // so future left-clicks still go through handleClick.
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    private func showPopover() {
        guard let button = statusItem.button,
              let key = monitor.currentSpaceKey else { return }

        let p = NSPopover()
        p.contentSize = NSSize(width: 260, height: 110)
        p.behavior = .transient
        p.contentViewController = NSHostingController(
            rootView: RenamePopoverView(
                spaceKey: key,
                store: store,
                dismiss: { [weak p] in p?.performClose(nil) }
            )
        )
        p.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        button.highlight(true)
        self.popover = p

        popoverCloseObserver = NotificationCenter.default.addObserver(
            forName: NSPopover.didCloseNotification,
            object: p,
            queue: .main
        ) { [weak self] _ in
            self?.statusItem.button?.highlight(false)
            self?.popover = nil
            if let obs = self?.popoverCloseObserver {
                NotificationCenter.default.removeObserver(obs)
            }
        }
    }
}
