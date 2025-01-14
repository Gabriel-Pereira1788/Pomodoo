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
    
    
    var initialTime:Double = 0.0
    
    var progress:Double {
        guard initialTime > 0 else { return 0.0 }
        return  1.0 - (timeElapsed / initialTime)
    }
    var timeString: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init() {
        FocuseeNotificationCenter.shared.checkNotificationPermission()
        TimerConfigNotifier.instance.addObserver(self)
        bundleIntervalValues()
    }
    
    func bundleIntervalValues() {
        shortBreakInterval = TimeInterval(self.timerDataStore.shortBreakValue * 60)
        longBreakInterval = TimeInterval(self.timerDataStore.longBreakValue * 60)
        focusBreakInterval = TimeInterval(self.timerDataStore.focusValue * 60)
        sessionsLimit = self.timerDataStore.sessionsLimitValue
        timeElapsed = focusBreakInterval
    }
    
    func onMainButtonPress() {
        //TODO: Implements a toggle to start and puase and block somethings based on timer state
    }
    
    func start() {
        
        guard uiState == .paused else { return }
        
        if initialTime == 0 {
            initialTime = timeElapsed
        }
        
        
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
        if(countSession >= sessionsLimit) {
            scheduleNotification(title: "🎉 Time to Recharge", body: "You’ve completed several cycles—amazing work! Recharge with a longer pause before the next session.")
            
            
            uiState = .breakTime
            changeTimerBreakElapsed(.long)
            countSession = 0
            return
        }
        
        if(timerBreak != .short) {
            scheduleNotification(title: "☕ Time for a Quick Break", body: "Take a breather—you’ve earned it! Stretch, grab some water, or just relax for a bit.")
            
            uiState = .breakTime
            countSession += 1
            changeTimerBreakElapsed(.short)
        } else {
            scheduleNotification(title: "🔔 Back to Work!", body: "Eliminate distractions and dive into deep work. Stay on track—your break is just around the corner!")
            
            reset()
            changeTimerBreakElapsed(.focus)
        }
    }
    
    private func scheduleNotification(title:String,body:String) {
        FocuseeNotificationCenter.shared.scheduleNotification(title: title, body:body, timeInterval: 0.1)
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
        initialTime = timeElapsed
        
    }
}


