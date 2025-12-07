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
            content.title = NSLocalizedString("notification_focus_title", comment: "Focus session complete title")
            content.body = NSLocalizedString("notification_focus_body", comment: "Focus session complete body")
        case .shortBreak:
            content.title = NSLocalizedString("notification_short_break_title", comment: "Short break complete title")
            content.body = NSLocalizedString("notification_short_break_body", comment: "Short break complete body")
        case .longBreak:
            content.title = NSLocalizedString("notification_long_break_title", comment: "Long break complete title")
            content.body = NSLocalizedString("notification_long_break_body", comment: "Long break complete body")
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

    // Schedule notification for workout timer completion
    func scheduleWorkoutNotification(
        mode: WorkoutMode,
        fireDate: Date,
        identifier: String = "workout_timer_completion"
    ) {
        // Cancel any existing notifications
        cancelTimerNotification(identifier: identifier)

        let content = UNMutableNotificationContent()

        switch mode {
        case .exercise:
            content.title = NSLocalizedString("notification_exercise_title", comment: "Exercise complete title")
            content.body = NSLocalizedString("notification_exercise_body", comment: "Exercise complete body")
        case .rest:
            content.title = NSLocalizedString("notification_rest_title", comment: "Rest complete title")
            content.body = NSLocalizedString("notification_rest_body", comment: "Rest complete body")
        }

        content.sound = .default
        content.categoryIdentifier = "WORKOUT_COMPLETE"

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
                print("Error scheduling workout notification: \(error)")
            } else {
                print("Workout notification scheduled for \(fireDate)")
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
