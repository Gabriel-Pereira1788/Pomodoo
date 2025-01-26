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

struct TimerNotificationContent {
    var title:String
    var body:String
}

struct TimerNotificationData {
    private static  let notificationContent:[TimerBreak:TimerNotificationContent] = [
        .long:TimerNotificationContent(
            title: "🎉 Time to Recharge",
            body:
                "You’ve completed several cycles—amazing work! Recharge with a longer pause before the next session."
        ),
        .focus:TimerNotificationContent(
            title: "🔔 Back to Work!",
            body:
                "Eliminate distractions and dive into deep work. Stay on track—your break is just around the corner!"
        ),
        .short:TimerNotificationContent(
            title: "☕ Time for a Quick Break",
            body:
                "Take a breather—you’ve earned it! Stretch, grab some water, or just relax for a bit."
        )
    ]
    
    static func getNotificationContent(for breakType:TimerBreak) -> TimerNotificationContent {
        return notificationContent[breakType] ?? TimerNotificationContent(title: "", body: "")
    }
}
