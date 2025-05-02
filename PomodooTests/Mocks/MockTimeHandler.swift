import Testing
import Foundation
@testable import Pomodoo

class MockTimeHandler:TimerHandlerProtocol {
    var block: ((TimerHandlerProtocol) -> Void)?
       var didSchedule = false

    func schedule(timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerHandlerProtocol) -> Void) {
           self.block = block
           didSchedule = true
       }

       func trigger() {
           block?(self)
       }

       func invalidate() {}
}
