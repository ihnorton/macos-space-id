import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let store = SpaceStore()
        let monitor = SpaceMonitor()
        statusBarController = StatusBarController(monitor: monitor, store: store)
        monitor.start()
    }
}
