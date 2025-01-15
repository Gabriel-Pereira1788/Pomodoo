//
//  GlobalState.swift
//  Focusee
//
//  Created by Gabriel Pereira on 11/01/25.
//

import SwiftUI



struct TimerConfigState {
    var focusValue:Int = 25
    var shortBreakValue:Int = 5
    var longBreakValue:Int = 15
    var sessionsLimitValue:Int = 4
}

class TimerDataStore:ObservableObject,TimerConfigObserver {
    static var shared = TimerDataStore()
    
    private init() {
        TimerConfigNotifier.instance.addObserver(self)
    }
    
    
    
    @AppStorage("focus-value") var focusValue = 25
    @AppStorage("short-break-value") var shortBreakValue = 5
    @AppStorage("long-break-value") var longBreakValue = 15
    @AppStorage("sessions-limit-value") var sessionsLimitValue = 4
    
    func didChangeTimerConfig(_ data: TimerConfig) {
        
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
