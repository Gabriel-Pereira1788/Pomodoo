import Foundation
import SwiftUI

class TimerPopUpViewModel: ObservableObject {
    @Published var uiState: TimerUIState = .paused
    @Published var renderUiState: TimerRenderUIState = .timerPopUp
    @Published var countSession = 0
    @Published var timerBreak: TimerBreak = .focus
    @Published var timeElapsed: TimeInterval = 25 * 60
    
    @ObservedObject var timerDataStore: TimerDataStore
    
    private var timer: Timer?
    var initialTime: Double = 0.0
    
    var progress: Double {
        guard initialTime > 0 else { return 0.0 }
        return 1.0 - (timeElapsed / initialTime)
    }
    
    var timeString: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        let value = String(format: "%02d:%02d", minutes, seconds)
        
        return value
    }
    
    init(timerDataStore:TimerDataStore) {
        self.timerDataStore = timerDataStore
        self.timerDataStore.reset = reset
        FocuseeNotificationCenter.shared.checkNotificationPermission()
        timeElapsed = timerDataStore.intervals[.focus] ?? 0.0
        
    }
    
    func onMainButtonPress() {
        
        uiState == .paused ? start() : pause()
    }
    
    func start() {
        
        guard uiState == .paused else { return }
        
        if initialTime == 0 {
            initialTime = timeElapsed
        }
        
        uiState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timeElapsed -= 1
            
            if self?.timeElapsed == 0 {
                self?.finishCurrentSession()
            }
        }
    }
    
    func pause() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func changeRenderUiState(to state: TimerRenderUIState) {
        renderUiState = state
    }
}

extension TimerPopUpViewModel {
    func renderSettingsView() -> some View {
        return SettingsView(
            goBack: {
                self.changeRenderUiState(to: .timerPopUp)
            }, viewModel: SettingsViewModel())
    }
}

extension TimerPopUpViewModel {
    private func finishCurrentSession() {
        //TODO: Refact
        if countSession >= timerDataStore.sessionsLimitValue {
            
            changeTimerBreakElapsed(.long)
            scheduleNotificationByTimerBreak(.long)
            countSession = 0
            uiState = .breakTime
            return
        }
        if timerBreak == .short || timerBreak == .long {
            
            reset()
            changeTimerBreakElapsed(.focus)
            scheduleNotificationByTimerBreak(.focus)
            
        } else {
            
            countSession += 1
            changeTimerBreakElapsed(.short)
            scheduleNotificationByTimerBreak(.short)
            uiState = .breakTime
        }
        
    }
    
    private func scheduleNotification(notificationContent: TimerNotificationContent) {
        FocuseeNotificationCenter.shared.scheduleNotification(
            title: notificationContent.title, body: notificationContent.body, timeInterval: 0.1)
    }
    
    private func reset() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
        
        changeTimerBreakElapsed(.focus)
    }
    
    private func scheduleNotificationByTimerBreak(_ breakType: TimerBreak) {
        let notificationContent = TimerNotificationData.getNotificationContent(for: breakType)
        scheduleNotification(notificationContent: notificationContent)
    }
    
    private func changeTimerBreakElapsed(_ breakType: TimerBreak) {
        let interval = timerDataStore.intervals[breakType] ?? 0.0
        
        initialTime = interval
        timeElapsed = interval
        timerBreak = breakType
        
    }
}
