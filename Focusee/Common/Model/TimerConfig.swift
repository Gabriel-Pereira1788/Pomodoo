enum TimerConfig:Identifiable {
    var id:String { self.title }
    case longBreak(Int)
    case shortBreak(Int)
    case focus(Int)
    case sessions(Int)
    
    
    var title:String {
        switch self {
        case .focus: return "Focus Session"
        case .shortBreak: return "Short break"
        case .longBreak: return "Long break"
        case .sessions: return "Long break after"
        }
    }
    
    var value:String {
        switch self {
        case .focus(let value): return formatOptionValue(value: value)
        case .shortBreak(let value): return formatOptionValue(value: value)
        case .longBreak(let value): return formatOptionValue(value: value)
        case .sessions(let value): return "\(value)"
        }
    }
    
    var label:String {
        switch self {
        case .sessions: return "Sess."
        default: return "min"
        }
    }
    
    func formatOptionValue(value:Int) -> String {
        if value >= 10 {
            return "\(value)"
        } else {
            return "0\(value)"
        }
    }
    
}
