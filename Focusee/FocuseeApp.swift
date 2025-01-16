import Combine
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
    
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject var timerPopUpViewModel = TimerPopUpViewModel(timerDataStore: TimerDataStore.shared)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(
                systemSymbolName: "clock", accessibilityDescription: "Menu Timer")
            button.imagePosition = .imageRight
            
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.rightMouseUp,.leftMouseUp])
            
            
        }
        
        timerPopUpViewModel.$timerBreak.sink { [weak self] value in
            self?.statusBarItem?.button?.image = NSImage(
                systemSymbolName: value == .focus ? "clock" : "cup.and.heat.waves",
                accessibilityDescription: "Menu Timer")
        }.store(in: &cancellables)
        
        timerPopUpViewModel.$timeElapsed.sink { [weak self] value in
            let minutes = Int(value) / 60
            let seconds = Int(value) % 60
            let value = String(format: "%02d:%02d", minutes, seconds)
            self?.statusBarItem?.button?.title = value
        }.store(in: &cancellables)
        
        popover = NSPopover()
        popover?.contentViewController = NSHostingController(
            rootView: TimerPopUpView(
                redirectToSettingsView:{},
                viewModel: timerPopUpViewModel))
        popover?.behavior = .transient
    }
    
    @objc func statusBarButtonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            showCustomMenu()
        } else {
            togglePopover(sender)
        }
    }
    
    
    
    @objc  func showCustomMenu() {
        let statusBarMenu = NSMenu(title: "Status Bar Menu")
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quitApplication),
            keyEquivalent: "")
        
        statusBarItem?.menu = statusBarMenu
        
        statusBarItem?.button?.performClick(nil)
        
        statusBarItem?.menu = nil
    }
    
    @objc func quitApplication() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if let button = statusBarItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
            } else {
                let buttonBounds = button.bounds
                
                if let statusBarItem = statusBarItem {
                    
                    statusBarItem.length = 60
                }
                
                let iconWidth = button.image?.size.width ?? 0
                let iconX = buttonBounds.midX - iconWidth / 2
                let iconRect = NSRect(
                    x: iconX,
                    y: 0,
                    width: 20,
                    height: buttonBounds.height
                )
                
                popover?.show(relativeTo: iconRect, of: button, preferredEdge: .minY)
            }
        }
    }
    
}
