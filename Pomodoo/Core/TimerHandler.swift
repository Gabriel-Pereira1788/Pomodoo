import SwiftUI

protocol TimerHandlerProtocol {
    func schedule(timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerHandlerProtocol) -> Void)
     func invalidate()
}

class TimerHandler: TimerHandlerProtocol {
    private var timer: Timer?
    
    func schedule(timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerHandlerProtocol) -> Void) {
          timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { _ in
              block(self)
          }
      }
    
    func invalidate() {
            timer?.invalidate()
            timer = nil
    }
}
