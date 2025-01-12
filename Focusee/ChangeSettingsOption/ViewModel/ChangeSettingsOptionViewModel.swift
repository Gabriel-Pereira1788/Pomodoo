import SwiftUI

class ChangeSettingsOptionViewModel:ObservableObject {
    @Published var option:TimerConfig
    @Published var value = 0
    
    init(option:TimerConfig){
        self.option = option
        self.value = Int(option.value) ?? 0
    }
    
    func incressValue() {
        print("INCRESS")
        value += 1
        changeTimerConfig(value: value)
    }
    
    func decressValue() {
        print("DECRESS")
        if(value > 0) {
            value -= 1
            changeTimerConfig(value: value)
        }
        
    }
    
    func changeTimerConfig(value:Int) {
        switch option {
        case .focus:
            TimerConfigNotifier.instance.changeValue(.focus(value))
            break
        case .longBreak:
            TimerConfigNotifier.instance.changeValue(.longBreak(value))
            break
        case .shortBreak:
            TimerConfigNotifier.instance.changeValue(.shortBreak(value))
            break
        case .sessions:
            TimerConfigNotifier.instance.changeValue(.sessions(value))
            break
        }
    }
    
}
