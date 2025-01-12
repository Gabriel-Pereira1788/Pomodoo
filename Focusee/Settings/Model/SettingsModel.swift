enum SettingsUIState {
    case settings
    case changeOption
}

//enum SettingsOptions:Identifiable {
//    var id:String { self.title }
//    
//    case focus(Int)
//    case short(Int)
//    case long(Int)
//    case sessions(Int)
//    
//    var title:String {
//        switch self {
//        case .focus: return "Focus Session"
//        case .short: return "Short break"
//        case .long: return "Long break"
//        case .sessions: return "Long break after"
//        }
//    }
//    
//    var value:String {
//        switch self {
//        case .focus(let value): return formatOptionValue(value: value)
//        case .short(let value): return formatOptionValue(value: value)
//        case .long(let value): return formatOptionValue(value: value)
//        case .sessions(let value): return "\(value)"
//        }
//    }
//    
//    var label:String {
//        switch self {
//        case .sessions: return "Sess."
//        default: return "min"
//        }
//    }
//    
//    func formatOptionValue(value:Int) -> String {
//        if value >= 10 {
//            return "\(value)"
//        } else {
//            return "0\(value)"
//        }
//    }
//}
