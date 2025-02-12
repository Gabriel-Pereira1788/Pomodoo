import Foundation
import SwiftUI

class PopoverManager {
    var popover: NSPopover?
    
    init() {
        popover = NSPopover()
        popover?.behavior = .transient
    }
    
    func setContentViewController(_ contentViewController: NSViewController) {
        self.popover?.contentViewController = contentViewController
    }
    
    @objc func open(from button: NSStatusBarButton) {
        let buttonBounds = button.bounds
        
        
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
    
    @objc func close(_ sender: Any?){
        
        popover?.performClose(sender)
    }
    
    func isShown() -> Bool {
        return popover?.isShown ?? false
    }
}
