//
//  SettingsModel.swift
//  Focusee
//
//  Created by Gabriel Pereira on 09/01/25.
//


enum SettingsUIState {
    case settings
    case changeOption
}

enum SettingsOptions:CaseIterable,Identifiable {
    var id:String { self.title }
    
    case focus
    case short
    case long
    case sessions
    
    var title:String {
        switch self {
        case .focus: return "Focus Session"
        case .short: return "Short break"
        case .long: return "Long break"
        case .sessions: return "Long break after"
        }
    }
    
    var value:String {
        switch self {
        case .focus: return "25"
        case .short: return "05"
        case .long: return "15"
        case .sessions: return "4"
        }
    }
    
    var label:String {
        switch self {
        case .sessions: return "Sess."
        default: return "min"
        }
    }
}
