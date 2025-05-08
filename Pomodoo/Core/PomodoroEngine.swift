import Combine
import Foundation
import SwiftUI

class PomodoroEngine: ObservableObject {
    
    @Published var countSession = 0
    @Published var phase: TimerBreak = .focus
    @Published var elapsedTime: TimeInterval = 25 * 60
    
    private var initialTime: Double = 0.0
    private var dataStore: DataStore!
    private var timerHandler: TimerHandlerProtocol
    private var timerConfigNotifier: TimerConfigNotifierProtocol
    private var intervals: [TimerBreak: TimeInterval] = [:]
    
    init(timerHandler: TimerHandlerProtocol, timerConfigNotifier: TimerConfigNotifierProtocol) {
        
        self.timerHandler = timerHandler
        self.timerConfigNotifier = timerConfigNotifier
        self.timerConfigNotifier.addObserver(self)
        
    }
    
    func setDataStore(_ dataStore: DataStore) {
        self.dataStore = dataStore
        bundleInitializeIntervals()
    }
    
    private func bundleInitializeIntervals() {
        intervals = [
            .long: TimeInterval(dataStore.longBreakValue * 60),
            .focus: TimeInterval(dataStore.focusValue * 60),
            .short: TimeInterval(dataStore.shortBreakValue * 60),
        ]
        
        elapsedTime = intervals[.focus] ?? 0.0
    }
    
    func start() {
        
        if initialTime == 0 {
            initialTime = elapsedTime
        }
        
        timerHandler.schedule(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime -= 1
            
            if self?.elapsedTime == 0 {
                self?.next()
            }
            
        }
    }
    
    func next() {
        stop()
        if countSession >= dataStore.sessionsLimitValue {
            countSession = 0
            changeTimerPhase(to: .long)
            return
        }
        
        if phase == .short || phase == .long {
            //ChangeTimerPhase
            changeTimerPhase(to: .focus)
        } else {
            countSession += 1
            //ChangeTimerphase
            changeTimerPhase(to: .short)
        }
    }
    
    func prev(callback: @escaping () -> Void) {
        if countSession > 0 {
            stop()
            if phase == .short || phase == .long {
                
                countSession -= 1
                changeTimerPhase(to: .focus)
            } else if phase == .focus {
                changeTimerPhase(to: .short)
                
            }
            
            callback()
        }
    }
    
    func stop() {
        timerHandler.invalidate()
    }
    
    func reset() {
        countSession = 0
        stop()
        changeTimerPhase(to: .focus)
    }
    
    func changeTimerPhase(to breakType: TimerBreak) {
        
        let interval = intervals[breakType] ?? 0.0
        
        initialTime = interval
        elapsedTime = interval
        phase = breakType
    }
    
    func getInitialTime() -> Double {
        return initialTime
    }
}

extension PomodoroEngine: TimerConfigObserver {
    func didChangeTimerConfig(_ data: TimerConfig) {
        print("TIMER-VIEW-MODEL-CHANGE-TIMER \(data)")
        switch data {
        case .shortBreak(let value):
            intervals[.short] = TimeInterval(value * 60)
            break
        case .longBreak(let value):
            intervals[.long] = TimeInterval(value * 60)
            break
        case .focus(let value):
            intervals[.focus] = TimeInterval(value * 60)
            break
        case .sessions(_):
            break
        }
        
        let interval = self.intervals[self.phase] ?? 0.0
        
        self.initialTime = interval
        self.elapsedTime = interval
    }
    
}
