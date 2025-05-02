import Testing
import Foundation
@testable import Pomodoo

class MockNotificationService:NotificationServiceProtocol {
    
    private var notificationContent:TimerNotificationContent?
    func requestNotificationPermissions() {
        print("REQUEST-NOTIF")
    }
    
    func checkNotificationPermission() {
        print("CHECK-NOTIFICATION")
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        notificationContent = TimerNotificationContent(title: title, body: body)
    }
    
    func getScheduleNotificationContent() -> TimerNotificationContent? {
        return notificationContent
    }
    
    
}
