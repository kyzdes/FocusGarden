//
//  NotificationManager.swift
//  FocusGarden
//
//  Created by Claude
//

import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    // Request notification permissions
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            completion(granted)
        }
    }

    // Check current authorization status
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    // Schedule notification for timer completion
    func scheduleTimerNotification(
        mode: TimerMode,
        fireDate: Date,
        identifier: String = "timer_completion"
    ) {
        // Cancel any existing notifications
        cancelTimerNotification()

        let content = UNMutableNotificationContent()

        switch mode {
        case .focus:
            content.title = "Focus Session Complete! 🎉"
            content.body = "Great work! Time for a break."
        case .shortBreak:
            content.title = "Break Complete! 💪"
            content.body = "Ready to get back to work?"
        case .longBreak:
            content.title = "Long Break Complete! ✨"
            content.body = "Feeling refreshed? Let's continue!"
        }

        content.sound = .default
        content.categoryIdentifier = "TIMER_COMPLETE"

        // Calculate time interval
        let timeInterval = fireDate.timeIntervalSinceNow

        guard timeInterval > 0 else {
            print("Cannot schedule notification in the past")
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(fireDate)")
            }
        }
    }

    // Cancel timer notification
    func cancelTimerNotification(identifier: String = "timer_completion") {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Timer notification cancelled")
    }

    // Remove all delivered notifications
    func removeAllDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }
}
