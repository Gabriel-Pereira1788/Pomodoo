import Foundation
//
//  FocuseeNotificationCenter.swift
//  Focusee
//
//  Created by Gabriel Pereira on 13/01/25.
//
import SwiftUI
import UserNotifications

class FocuseeNotificationCenter {
    static let shared = FocuseeNotificationCenter()
    private var permissionGranted = false

    private init() {
    }

    func requestNotificationPermissions() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting permissions: \(error.localizedDescription)")
                }
                self?.permissionGranted = granted
            }
        }
    }

    func checkNotificationPermission() {

        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                let permission = settings.authorizationStatus == .authorized

                if !permission {
                    print("PERMISSION-NOT-GRANTED")
                    self?.requestNotificationPermissions()
                }
                self?.permissionGranted = permission
            }
        }
    }

    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        guard permissionGranted else {
            print("Permission not granted for notifications.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

}
