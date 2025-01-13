import SwiftUI
import Foundation

class TimerPopUpViewModel:ObservableObject, TimerConfigObserver{
    @Published var uiState:TimerUIState = .paused
    @Published var renderUiState:TimerRenderUIState = .timerPopUp
    
    @Published var countSession = 0
    @Published var timerBreak:TimerBreak = .focus
    
    @Published var timeElapsed: TimeInterval = 25 * 60
    @ObservedObject var timerDataStore = TimerDataStore.shared
    
    var shortBreakInterval:TimeInterval = 5 * 60
    var longBreakInterval:TimeInterval = 15 * 60
    var focusBreakInterval:TimeInterval = 25 * 60
    var sessionsLimit = 4
    
    private var timer: Timer?
    
    
    init() {
        TimerConfigNotifier.instance.addObserver(self)
        bundleIntervalValues()
        
    }
    
    var timeString: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func bundleIntervalValues() {
        shortBreakInterval = TimeInterval(self.timerDataStore.shortBreakValue * 60)
        longBreakInterval = TimeInterval(self.timerDataStore.longBreakValue * 60)
        focusBreakInterval = TimeInterval(self.timerDataStore.focusValue * 60)
        sessionsLimit = self.timerDataStore.sessionsLimitValue
        timeElapsed = focusBreakInterval
    }
    
    func start() {
        
        guard uiState == .paused else { return }
        
        uiState = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timeElapsed -= 1
            if(self?.timeElapsed == 0) {
                self?.finishCurrentSession()
            }
        }
    }
    
    func pause() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func changeRenderUiState(to state:TimerRenderUIState) {
        renderUiState = state
    }
    
    func didChangeTimerConfig(_ data: TimerConfig) {
        print("TIMERPOPUPVIEW: \(data)")
        switch data {
        case .shortBreak(let value):
            shortBreakInterval = TimeInterval(value * 60)
            break
        case .longBreak(let value):
            longBreakInterval = TimeInterval(value * 60)
            break
        case .focus(let value):
            focusBreakInterval = TimeInterval(value * 60)
            break
        case .sessions(let value):
            sessionsLimit = value
            break
        }
        
        reset()
    }
    
}

extension TimerPopUpViewModel {
    func renderSettingsView() -> some View  {
        return SettingsView(goBack:{
            self.changeRenderUiState(to: .timerPopUp)
        },viewModel: SettingsViewModel())
    }
}

extension TimerPopUpViewModel {
    private func finishCurrentSession() {
        
        print("COUNT SESSION: \(countSession) SESSIONS LIMIT: \(sessionsLimit)")
        if(countSession >= sessionsLimit) {
            FocuseeNotificationCenter.shared.scheduleNotification(title: "Long Break", body: "Long Break Body", timeInterval: .zero)
            uiState = .breakTime
            changeTimerBreakElapsed(.long)
            countSession = 0
            return
        }
        
        if(timerBreak != .short) {
            FocuseeNotificationCenter.shared.scheduleNotification(title: "Short Break", body: "Short Break Body", timeInterval: .zero)
            uiState = .breakTime
            countSession += 1
            changeTimerBreakElapsed(.short)
        } else {
            FocuseeNotificationCenter.shared.scheduleNotification(title: "Focus Now", body: "Focus Now Body", timeInterval: .zero)
            reset()
            changeTimerBreakElapsed(.focus)
        }
    }
    
    
    
    private func reset() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
        changeTimerBreakElapsed(.focus)
        
    }
    
    private func changeTimerBreakElapsed(_ breakType: TimerBreak) {
        switch breakType {
        case .long:
            timeElapsed = longBreakInterval
            break
        case .short:
            timeElapsed = shortBreakInterval
            break
        case .focus:
            timeElapsed = focusBreakInterval
            break
        }
        timerBreak = breakType
        
    }
}


