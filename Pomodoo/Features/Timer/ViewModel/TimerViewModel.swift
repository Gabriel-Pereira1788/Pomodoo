import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var countSession = 0
    @Published var uiState: TimerUIState = .paused
    @Published var timerBreak: TimerBreak = .focus
    @Published var elapsedTime: TimeInterval = 25 * 60
    
    private var notificationService:NotificationServiceProtocol
    private var timerConfigNotifier:TimerConfigNotifierProtocol
    private var dataStore:DataStore!
    private var timer: Timer?
    private var initialTime: Double = 0.0
    private var openPopover: () -> Void = {}
    
    var progress: Double {
        guard initialTime > 0 else { return 0.0 }
        return (elapsedTime / initialTime)
    }
    
    var intervals:[TimerBreak:TimeInterval] = [:]
    
    var timeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let value = String(format: "%02d:%02d", minutes, seconds)
        
        return value
    }
    
    init(timerConfigNotifier:TimerConfigNotifierProtocol,notificationService:NotificationServiceProtocol) {
        self.timerConfigNotifier = timerConfigNotifier
        self.notificationService = notificationService
        self.timerConfigNotifier.addObserver(self)
        NotificationService.shared.checkNotificationPermission()
    }
    
    private func bundleInitializeIntervals() {
        intervals =  [
            .long:TimeInterval(dataStore.longBreakValue * 60),
            .focus:TimeInterval(dataStore.focusValue * 60),
            .short:TimeInterval(dataStore.shortBreakValue * 60)
        ]
        
        elapsedTime = intervals[.focus] ?? 0.0
    }
    
    func setOpenPopoverFunc(_ callback: @escaping () -> Void) {
        openPopover = callback
    }
    
    func setDataStore(_ dataStore:DataStore){
        self.dataStore = dataStore
        bundleInitializeIntervals()
    }
    
    func start() {
        guard uiState == .paused else { return }
        
        if initialTime == 0 {
            initialTime = elapsedTime
        }
        
        uiState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedTime -= 1
            
            if self?.elapsedTime == 0 {
                self?.nextPhase()
            }
        }
    }
    
    func pause() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
    }
}

extension TimerViewModel:TimerConfigObserver {
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
        
        let interval = self.intervals[self.timerBreak] ?? 0.0
        
        self.initialTime = interval
        self.elapsedTime = interval
    }
}

extension TimerViewModel {
    
    func onReset() {
        countSession = 0
        uiState = .paused
        resetTimer()
        changeTimerBreakElapsed(.focus)
    }
    
    func prevPhase() {
        if countSession > 0 {
            resetTimer()
            uiState = .paused
            if timerBreak == .short || timerBreak == .long {
                
                countSession -= 1
                handleCycleTransition(from: .focus)
            } else if timerBreak == .focus {
                
                handleCycleTransition(from: .short)
                
            }
        }
        
    }
    
    func nextPhase() {
        resetTimer()
        uiState = .paused
        openPopover()
        if countSession >= dataStore.sessionsLimitValue {
            countSession = 0
            handleCycleTransition(from: .long)
            return
        }
        
        if timerBreak == .short || timerBreak == .long {
            
            handleCycleTransition(from: .focus)
            
        } else {
            countSession += 1
            handleCycleTransition(from: .short)
        }
        
    }
    
    private func handleCycleTransition(from breakType: TimerBreak) {
        
        let notificationContent = TimerNotificationData.getNotificationContent(for: breakType)
        
        changeTimerBreakElapsed(breakType)
        scheduleNotification(notificationContent: notificationContent)
    }
    
    private func scheduleNotification(notificationContent: TimerNotificationContent) {
        NotificationService.shared.scheduleNotification(
            title: notificationContent.title, body: notificationContent.body, timeInterval: 0.1)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func changeTimerBreakElapsed(_ breakType: TimerBreak) {
        let interval = intervals[breakType] ?? 0.0
        
        initialTime = interval
        elapsedTime = interval
        timerBreak = breakType
    }
}
