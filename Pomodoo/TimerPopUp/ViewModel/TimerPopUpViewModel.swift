import Foundation
import SwiftUI

class TimerPopUpViewModel: ObservableObject {
    @Published var countSession = 0
    @Published var uiState: TimerUIState = .paused
    @Published var timerBreak: TimerBreak = .focus
    @Published var elapsedTime: TimeInterval = 25 * 60
    
    @ObservedObject var timerDataStore = TimerDataStore.shared
    
    private var timer: Timer?
    private var initialTime: Double = 0.0
    private var openPopover: () -> Void = { }
    
    var progress: Double {
        guard initialTime > 0 else { return 0.0 }
        return 1.0 - (elapsedTime / initialTime)
    }
    
    var timeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let value = String(format: "%02d:%02d", minutes, seconds)
        
        return value
    }
    
    init() {
        self.timerDataStore.callbackChange = {
            let interval = self.timerDataStore.intervals[self.timerBreak] ?? 0.0
            
            self.initialTime = interval
            self.elapsedTime = interval
        }
        
        FocuseeNotificationCenter.shared.checkNotificationPermission()
        elapsedTime = timerDataStore.intervals[.focus] ?? 0.0
        
    }
    
    func setOpenPopoverFunc(_ callback:@escaping () -> Void) {
        openPopover = callback
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

extension TimerPopUpViewModel {
    private func nextPhase() {
        if countSession >= timerDataStore.sessionsLimitValue {
            
            countSession = 0
            uiState = .breakTime
            handleCycleTransition(from: .long)
            return
        }
        
        if timerBreak == .short || timerBreak == .long {
            
            resetTimer()
            uiState = .paused
            handleCycleTransition(from: .focus)
            openPopover()
        } else {
            
            countSession += 1
            uiState = .breakTime
            handleCycleTransition(from: .short)
        }
        
    }
    
    private func handleCycleTransition(from breakType:TimerBreak) {
        
        let notificationContent = TimerNotificationData.getNotificationContent(for: breakType)
        
        changeTimerBreakElapsed(breakType)
        scheduleNotification(notificationContent: notificationContent)
    }
    
    private func scheduleNotification(notificationContent: TimerNotificationContent) {
        FocuseeNotificationCenter.shared.scheduleNotification(
            title: notificationContent.title, body: notificationContent.body, timeInterval: 0.1)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    private func changeTimerBreakElapsed(_ breakType: TimerBreak) {
        let interval = timerDataStore.intervals[breakType] ?? 0.0
        
        initialTime = interval
        elapsedTime = interval
        timerBreak = breakType
    }
}

extension TimerPopUpViewModel {

}
