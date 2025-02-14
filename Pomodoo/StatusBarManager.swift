import SwiftUI

class StatusBarManager {
    private var settingsWindow: NSWindow?
    private var statusBarItem: NSStatusItem?

    func setStatusBarItem(_ statusBarItem: NSStatusItem?) {
        self.statusBarItem = statusBarItem
    }

    @objc private func quitApplication() {
        NSApplication.shared.terminate(self)
    }

    @objc func showCustomMenu() {
        let statusBarMenu = NSMenu(title: "Status Bar Menu")

        let quitAppItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitApplication),
            keyEquivalent: "q"
        )
        quitAppItem.target = self

        statusBarMenu.addItem(quitAppItem)
        statusBarItem?.menu = statusBarMenu
        statusBarItem?.button?.performClick(nil)
        statusBarItem?.menu = nil
    }

}
