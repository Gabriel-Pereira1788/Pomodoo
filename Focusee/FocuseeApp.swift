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
        Settings {
            EmptyView()
        }
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
        popover?.contentViewController = NSHostingController(rootView: TimerPopUpView(redirectToSettingsView: navigateToScreen, viewModel: TimerPopUpViewModel()))
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
    
    func navigateToScreen() {
        NSApp.activate(ignoringOtherApps: true)
        
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width:260, height: 200),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        newWindow.title = "Focusee Settings"
        newWindow.isReleasedWhenClosed = false
        newWindow.contentView = NSHostingView(rootView: SettingsView(goBack:{},viewModel: SettingsViewModel()))
        
        
        newWindow.makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Não encerra o app quando a janela principal é fechada
    }
}
