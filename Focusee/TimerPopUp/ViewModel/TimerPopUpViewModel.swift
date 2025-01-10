import SwiftUI
import Foundation

class TimerPopUpViewModel:ObservableObject {
    @Published var countSession = 0
    @Published var uiState:TimerUIState = .paused
    @Published var renderUiState:TimerRenderUIState = .timerPopUp
    @Published var timerBreak:TimerBreak = .none
    @Published var timeElapsed: TimeInterval = TimerBreak.none.timeInterval
    
    private var timer: Timer?
    
    var timeString: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
        reset()
        
        if(countSession >= 4) {
            changeTimerBreak(.long)
            countSession = 0
            return
        }
        
        if(timerBreak != .short) {
            countSession += 1
            changeTimerBreak(.short)
        } else {
            changeTimerBreak(.none)
        }
        
    }
    
    private func reset() {
        uiState = .paused
        timer?.invalidate()
        timer = nil
        changeTimerBreak(.none)
        
    }
    
    private func changeTimerBreak(_ breakType: TimerBreak) {
        timerBreak = breakType
        timeElapsed = breakType.timeInterval
    }
}


