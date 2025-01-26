import Combine
import SwiftUI

@main
struct FocuseeApp: App {
    let persistenceController = PersistenceController.shared
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            TimerSettingsView(goBack: {}, viewModel: TimerSettingsViewModel())
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    private let statusBarManager = StatusBarManager()
    private let popoverManager = PopoverManager()
    
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject var timerPopUpViewModel = TimerPopUpViewModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarManager.setStatusBarItem(statusBarItem)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(
                systemSymbolName: "clock", accessibilityDescription: "Menu Timer")
            button.imagePosition = .imageRight
            
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.rightMouseUp,.leftMouseUp])
            timerPopUpViewModel.setOpenPopoverFunc( {
                self.openPopover(from: button)
            })
            
        }
        
        timerPopUpViewModel.$timerBreak.sink { [weak self] value in
            self?.statusBarItem?.button?.image = NSImage(
                systemSymbolName: value == .focus ? "clock" : "cup.and.heat.waves",
                accessibilityDescription: "Menu Timer")
        }.store(in: &cancellables)
        
        timerPopUpViewModel.$elapsedTime.sink { [weak self] value in
            let minutes = Int(value) / 60
            let seconds = Int(value) % 60
            let value = String(format: "%02d:%02d", minutes, seconds)
            self?.statusBarItem?.button?.title = value
        }.store(in: &cancellables)
        
        let hostingController = NSHostingController(
            rootView: TimerPopUpView(
                viewModel: timerPopUpViewModel
            )
        )
        
        popoverManager.setContentViewController(hostingController)
    }
    
    @objc func statusBarButtonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            statusBarManager.showCustomMenu()
        } else {
            togglePopover(sender)
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if let button = statusBarItem?.button {
            if popoverManager.isShown() {
                popoverManager.close(sender)
            } else {
                openPopover(from:button)
            }
        }
    }
    
    @objc func openPopover(from button:NSStatusBarButton)
    {
        if let statusBarItem = statusBarItem {
            
            statusBarItem.length = 60
        }
        
        popoverManager.open(from: button)
    }
    
    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return true
    }
}
