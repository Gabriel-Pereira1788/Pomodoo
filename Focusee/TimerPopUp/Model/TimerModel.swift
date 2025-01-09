import Foundation


enum TimerBreak:Int {
    case long
    case short
    case none
    
    var timeInterval:Double {
        switch self {
        case .long: return 10 * 60
        case .short: return 1 * 60
        case .none: return 1 * 60
        }
    }
}

enum TimerUIState {
    case running
    case paused
}
