import SwiftUI

class DataStore:ObservableObject,TimerConfigObserver {
    private let timerConfigNotifier:TimerConfigNotifierProtocol
    
    init(timerConfigNotifier:TimerConfigNotifierProtocol){
        self.timerConfigNotifier = timerConfigNotifier
        timerConfigNotifier.addObserver(self)
    }
    
    @AppStorage("focus-value") var focusValue = 25
    @AppStorage("short-break-value") var shortBreakValue = 5
    @AppStorage("long-break-value") var longBreakValue = 15
    @AppStorage("sessions-limit-value") var sessionsLimitValue = 4
    @AppStorage("primary-color") var primaryColor = Color(.primay)
    @AppStorage("secondary-color") var secondaryColor = Color(.secondary)
    
    func didChangeTimerConfig(_ data: TimerConfig) {
        print("DATA-SOTRE-CHANGE-TIMER \(data)")
        switch data {
        case .shortBreak(let value):
            shortBreakValue = value
            break
        case .longBreak(let value):
            longBreakValue = value
            break
        case .focus(let value):
            focusValue = value
            break
        case .sessions(let value):
            sessionsLimitValue = value
            break
            
        }
    }
    
}
