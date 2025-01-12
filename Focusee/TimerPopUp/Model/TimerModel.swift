import Foundation


enum TimerBreak {
    case long
    case short
    case focus
    
    var timeInterval:Double {
        switch self {
        case .long: return 15 * 60
        case .short: return 5 * 60
        case .focus: return 25 * 60
        }
    }
    
    var description:String {
        switch self {
        case .long: return "Long Break"
        case .short: return "Short Break"
        case .focus: return "Focus"
        }
    }
}

enum TimerUIState {
    case running
    case breakTime
    case paused
}

enum TimerRenderUIState {
    case timerPopUp
    case settings
}
