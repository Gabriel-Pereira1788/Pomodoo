import SwiftUI

class SettingsOptionViewModel:ObservableObject {
    @Published var option:TimerConfig
    @Published var value = 0
    private var timerConfigNotifier:TimerConfigNotifierProtocol
    
    init(option:TimerConfig,timerConfigNotifier:TimerConfigNotifierProtocol){
        self.option = option
        self.timerConfigNotifier = timerConfigNotifier
        
        self.value = Int(option.value) ?? 0
    }
    
    func incressValue() {
        value += 1
        changeTimerConfig(value: value)
    }
    
    func decressValue() {
        if(value > 1) {
            value -= 1
            changeTimerConfig(value: value)
        }
        
    }
    
    func changeTimerConfig(value:Int) {
        switch option {
        case .focus:
            timerConfigNotifier.changeValue(.focus(value))
            break
        case .longBreak:
            timerConfigNotifier.changeValue(.longBreak(value))
            break
        case .shortBreak:
            timerConfigNotifier.changeValue(.shortBreak(value))
            break
        case .sessions:
            timerConfigNotifier.changeValue(.sessions(value))
            break
        }
    }
    
}
