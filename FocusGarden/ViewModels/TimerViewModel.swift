//
//  TimerViewModel.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import Combine
import UIKit
#if canImport(ActivityKit)
import ActivityKit
#endif

enum TimerMode: String, CaseIterable {
    case focus = "Focus Time"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var localizedTitle: String {
        switch self {
        case .focus:
            return NSLocalizedString("focus_time", comment: "Focus mode title")
        case .shortBreak:
            return NSLocalizedString("short_break", comment: "Short break mode title")
        case .longBreak:
            return NSLocalizedString("long_break", comment: "Long break mode title")
        }
    }

    var color: String {
        switch self {
        case .focus: return "FocusColor"
        case .shortBreak: return "BreakColor"
        case .longBreak: return "LongBreakColor"
        }
    }

    var gradientColors: (String, String) {
        switch self {
        case .focus: return ("FocusGradient1", "FocusGradient2")
        case .shortBreak: return ("BreakGradient1", "BreakGradient2")
        case .longBreak: return ("LongBreakGradient1", "LongBreakGradient2")
        }
    }
}

class TimerViewModel: ObservableObject {
    @Published var mode: TimerMode = .focus
    @Published var timeLeft: Int = 0
    @Published var isRunning: Bool = false
    @Published var completedCycles: Int = 0

    var settings: TimerSettings
    var onFocusComplete: () -> Void
    var onBreakComplete: () -> Void

    private var timer: Timer?
    private var endTime: Date?
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

    private var totalTime: Int {
        switch mode {
        case .focus:
            return settings.focusTime * 60
        case .shortBreak:
            return settings.breakTime * 60
        case .longBreak:
            return settings.longBreakTime * 60
        }
    }

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalTime - timeLeft) / Double(totalTime)
    }

    init(settings: TimerSettings, onFocusComplete: @escaping () -> Void, onBreakComplete: @escaping () -> Void) {
        self.settings = settings
        self.onFocusComplete = onFocusComplete
        self.onBreakComplete = onBreakComplete
        self.timeLeft = settings.focusTime * 60

        setupBackgroundObservers()
        restoreTimerIfNeeded()
    }

    private func restoreTimerIfNeeded() {
        // Check if there's a saved timer state
        guard let savedEndTime = UserDefaults.standard.object(forKey: "timerEndTime") as? TimeInterval,
              let savedModeRaw = UserDefaults.standard.string(forKey: "timerMode"),
              let savedMode = TimerMode(rawValue: savedModeRaw) else {
            return
        }

        let endTime = Date(timeIntervalSince1970: savedEndTime)
        let now = Date()
        let remainingTime = Int(endTime.timeIntervalSince(now))

        if remainingTime > 0 {
            // Timer is still running - restore state
            self.mode = savedMode
            self.endTime = endTime
            self.timeLeft = remainingTime
            self.isRunning = true

            // Restore completed cycles
            if let savedCycles = UserDefaults.standard.object(forKey: "timerCompletedCycles") as? Int {
                self.completedCycles = savedCycles
            }

            // Restart the UI update timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }

                if let endTime = self.endTime {
                    let now = Date()
                    let remaining = Int(endTime.timeIntervalSince(now))

                    if remaining > 0 {
                        self.timeLeft = remaining
                    } else {
                        self.timeLeft = 0
                        self.handleTimerComplete()
                    }
                }
            }
            RunLoop.current.add(timer!, forMode: .common)
        } else {
            // Timer expired while app was closed - clean up
            UserDefaults.standard.removeObject(forKey: "timerEndTime")
            UserDefaults.standard.removeObject(forKey: "timerMode")
            UserDefaults.standard.removeObject(forKey: "timerCompletedCycles")
        }
    }

    func toggleTimer() {
        isRunning.toggle()

        if isRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }

    func resetTimer() {
        stopTimer()
        timeLeft = totalTime
    }

    func switchMode(_ newMode: TimerMode) {
        guard !isRunning else { return }

        mode = newMode
        timeLeft = totalTime
    }

    private func setupBackgroundObservers() {
        // Observe app going to background
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        // Observe app coming to foreground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func appDidEnterBackground() {
        if isRunning {
            // Save the end time and state
            if let endTime = endTime {
                UserDefaults.standard.set(endTime.timeIntervalSince1970, forKey: "timerEndTime")
                UserDefaults.standard.set(mode.rawValue, forKey: "timerMode")
                UserDefaults.standard.set(completedCycles, forKey: "timerCompletedCycles")
            }
        }
    }

    @objc private func appWillEnterForeground() {
        if isRunning {
            updateTimeFromBackground()
        }
    }

    private func updateTimeFromBackground() {
        guard let endTime = endTime else { return }

        let now = Date()
        let remainingTime = Int(endTime.timeIntervalSince(now))

        if remainingTime <= 0 {
            // Timer completed while in background
            timeLeft = 0
            handleTimerComplete()
        } else {
            // Update remaining time
            timeLeft = remainingTime
        }
    }

    private func startTimer() {
        // Calculate end time
        endTime = Date().addingTimeInterval(TimeInterval(timeLeft))

        // Schedule notification
        if let endTime = endTime {
            NotificationManager.shared.scheduleTimerNotification(
                mode: mode,
                fireDate: endTime
            )
        }

        #if canImport(ActivityKit)
        startLiveActivity(totalSeconds: totalTime, remaining: timeLeft)
        #endif

        // Start UI update timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if let endTime = self.endTime {
                let now = Date()
                let remaining = Int(endTime.timeIntervalSince(now))

                if remaining > 0 {
                    self.timeLeft = remaining
                    #if canImport(ActivityKit)
                    self.updateLiveActivity(remaining: remaining)
                    #endif
                } else {
                    self.timeLeft = 0
                    self.handleTimerComplete()
                }
            }
        }

        // Keep timer running in background
        RunLoop.current.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        endTime = nil

        // Cancel scheduled notification
        NotificationManager.shared.cancelTimerNotification()

        // Clear saved timer state
        UserDefaults.standard.removeObject(forKey: "timerEndTime")
        UserDefaults.standard.removeObject(forKey: "timerMode")
        UserDefaults.standard.removeObject(forKey: "timerCompletedCycles")

        #if canImport(ActivityKit)
        endLiveActivity()
        #endif
    }

    private func handleTimerComplete() {
        stopTimer()

        // Play sound if enabled
        if settings.soundEnabled {
            SoundManager.shared.playCompletionSound()
        }

        if mode == .focus {
            // Focus completed
            completedCycles += 1
            onFocusComplete()

            // Switch to break mode
            if completedCycles % 4 == 0 {
                mode = .longBreak
                timeLeft = settings.longBreakTime * 60
            } else {
                mode = .shortBreak
                timeLeft = settings.breakTime * 60
            }
        } else {
            // Break completed (short or long)
            onBreakComplete()

            // Switch back to focus mode
            mode = .focus
            timeLeft = settings.focusTime * 60
        }

        // Auto-start next session (optional - can be removed if you want manual start)
        // isRunning = true
        // startTimer()
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    func updateSettings(_ newSettings: TimerSettings) {
        // Don't update if timer is running
        guard !isRunning else { return }

        settings = newSettings

        // Reset current timer with new duration
        timeLeft = totalTime
    }

#if canImport(ActivityKit)
    private func startLiveActivity(totalSeconds: Int, remaining: Int) {
        guard #available(iOS 16.1, *) else { return }
        LiveActivityManager.shared.start(
            title: NSLocalizedString("app_title", comment: "App title"),
            mode: mode,
            totalSeconds: totalSeconds,
            remainingSeconds: remaining
        )
    }

    private func updateLiveActivity(remaining: Int) {
        guard #available(iOS 16.1, *) else { return }
        LiveActivityManager.shared.update(
            mode: mode,
            totalSeconds: totalTime,
            remainingSeconds: remaining
        )
    }

    private func endLiveActivity() {
        guard #available(iOS 16.1, *) else { return }
        LiveActivityManager.shared.end()
    }
#else
    private func startLiveActivity(totalSeconds: Int, remaining: Int) {}
    private func updateLiveActivity(remaining: Int) {}
    private func endLiveActivity() {}
#endif

    deinit {
        stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
}

#if canImport(ActivityKit)
@available(iOS 16.1, *)
struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var remainingSeconds: Int
        var totalSeconds: Int
        var modeTitle: String
    }

    var title: String
}

@available(iOS 16.1, *)
class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var activity: Activity<TimerActivityAttributes>?

    func start(title: String, mode: TimerMode, totalSeconds: Int, remainingSeconds: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        // End previous activity if it exists
        if activity != nil {
            end()
        }

        let attributes = TimerActivityAttributes(title: title)
        let state = TimerActivityAttributes.ContentState(
            remainingSeconds: remainingSeconds,
            totalSeconds: totalSeconds,
            modeTitle: mode.localizedTitle
        )

        do {
            let content = ActivityContent(
                state: state,
                staleDate: nil
            )
            activity = try Activity<TimerActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Failed to start live activity: \(error)")
        }
    }

    func update(mode: TimerMode, totalSeconds: Int, remainingSeconds: Int) {
        guard let activity else { return }
        let state = TimerActivityAttributes.ContentState(
            remainingSeconds: remainingSeconds,
            totalSeconds: totalSeconds,
            modeTitle: mode.localizedTitle
        )

        Task {
            let content = ActivityContent(
                state: state,
                staleDate: nil
            )
            await activity.update(content)
        }
    }

    func end() {
        guard let activity else { return }
        Task {
            let content = ActivityContent(
                state: activity.content.state,
                staleDate: nil
            )
            await activity.end(content, dismissalPolicy: .immediate)
        }
        self.activity = nil
    }
}
#endif
