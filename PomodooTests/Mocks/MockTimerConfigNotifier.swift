import Testing
@testable import Pomodoo

class MockTimerConfigNotifier:TimerConfigNotifierProtocol {
    static var shared: TimerConfigNotifierProtocol = MockTimerConfigNotifier()
    
    func addObserver(_ observer: any Pomodoo.TimerConfigObserver) {
        print("ADD-OBS")
    }
    
    func changeValue(_ config: Pomodoo.TimerConfig) {
        print("change-value")
    }
    
}
