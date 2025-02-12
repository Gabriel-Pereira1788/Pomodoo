import SwiftUI


class TimerDataStore:ObservableObject,TimerConfigObserver {
    static var shared = TimerDataStore()
    
    @AppStorage("focus-value") var focusValue = 25
    @AppStorage("short-break-value") var shortBreakValue = 5
    @AppStorage("long-break-value") var longBreakValue = 15
    @AppStorage("sessions-limit-value") var sessionsLimitValue = 4
    @AppStorage("primary-color") var primaryColor = Color(.primay)
    @AppStorage("secondary-color") var secondaryColor = Color(.secondary)
    
    var intervals:[TimerBreak:TimeInterval] = [:]
    var callbackChange:() -> Void = {}
        
    private init() {
        bundleInitializeIntervals()
        TimerConfigNotifier.instance.addObserver(self)
        
    }
    
    private func bundleInitializeIntervals() {
        intervals =  [
            .long:TimeInterval(longBreakValue * 60),
            .focus:TimeInterval(focusValue * 60),
            .short:TimeInterval(shortBreakValue * 60)
        ]
    }
    func didChangeTimerConfig(_ data: TimerConfig) {
        
        switch data {
        case .shortBreak(let value):
            shortBreakValue = value
            intervals[.short] = TimeInterval(value * 60)
            break
        case .longBreak(let value):
            longBreakValue = value
            intervals[.long] = TimeInterval(value * 60)
            break
        case .focus(let value):
            focusValue = value
            intervals[.focus] = TimeInterval(value * 60)
            break
        case .sessions(let value):
            sessionsLimitValue = value
            break
        }
        
        callbackChange()
    }
    
}
