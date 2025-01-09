//
//  FocuseeApp.swift
//  Focusee
//
//  Created by Gabriel Pereira on 07/01/25.
//

import SwiftUI

@main
struct FocuseeApp: App {
    let persistenceController = PersistenceController.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.defaultAppStorage(UserDefaults.standard)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Menu Widget")
            button.action = #selector(togglePopover(_:))
        }

        
        popover = NSPopover()
        popover?.contentViewController = NSHostingController(rootView: TimerPopUpView(viewModel: TimerPopUpViewModel()))
        popover?.behavior = .transient
    }

    @objc func togglePopover(_ sender: Any?) {
        if let button = statusBarItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
