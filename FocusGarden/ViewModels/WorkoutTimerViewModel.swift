//
//  WorkoutTimerViewModel.swift
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

class WorkoutTimerViewModel: ObservableObject {
    @Published var mode: WorkoutMode = .exercise
    @Published var timeLeft: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentCycle: Int = 0
    @Published var totalCycles: Int = 0
    @Published var isWorkoutActive: Bool = false

    var settings: WorkoutSettings
    var onCycleComplete: () -> Void
    var onWorkoutComplete: () -> Void

    private var timerSource: DispatchSourceTimer?
    private var endTime: Date?

    private var totalTime: Int {
        switch mode {
        case .exercise:
            return settings.exerciseTime
        case .rest:
            return settings.restTime
        }
    }

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalTime - timeLeft) / Double(totalTime)
    }

    init(settings: WorkoutSettings, onCycleComplete: @escaping () -> Void, onWorkoutComplete: @escaping () -> Void) {
        self.settings = settings
        self.onCycleComplete = onCycleComplete
        self.onWorkoutComplete = onWorkoutComplete
        self.timeLeft = settings.exerciseTime

        setupBackgroundObservers()
        restoreTimerIfNeeded()
    }

    private func restoreTimerIfNeeded() {
        // Check if there's a saved timer state
        guard let savedEndTime = UserDefaults.standard.object(forKey: "workoutTimerEndTime") as? TimeInterval,
              let savedModeRaw = UserDefaults.standard.string(forKey: "workoutTimerMode"),
              let savedMode = WorkoutMode(rawValue: savedModeRaw) else {
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

            // Restore workout state
            if let savedCurrentCycle = UserDefaults.standard.object(forKey: "workoutCurrentCycle") as? Int,
               let savedTotalCycles = UserDefaults.standard.object(forKey: "workoutTotalCycles") as? Int {
                self.currentCycle = savedCurrentCycle
                self.totalCycles = savedTotalCycles
                self.isWorkoutActive = true
            }

            // Restart the UI update timer
            timerSource = DispatchSource.makeTimerSource(queue: .main)
            timerSource?.schedule(deadline: .now(), repeating: 1.0)
            timerSource?.setEventHandler { [weak self] in
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
            timerSource?.resume()
        } else {
            // Timer expired while app was closed - clean up
            clearSavedState()
        }
    }

    func startWorkout(cycles: Int) {
        guard !isWorkoutActive else { return }

        totalCycles = cycles
        currentCycle = 1
        isWorkoutActive = true
        mode = .exercise
        timeLeft = settings.exerciseTime

        startTimer()
    }

    func stopWorkout() {
        stopTimer()
        isWorkoutActive = false
        currentCycle = 0
        totalCycles = 0
        mode = .exercise
        timeLeft = settings.exerciseTime
        clearSavedState()
    }

    func toggleTimer() {
        guard isWorkoutActive else { return }

        isRunning.toggle()

        if isRunning {
            startTimer()
        } else {
            pauseTimer()
        }
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
        if isRunning && isWorkoutActive {
            // Save the end time and state
            if let endTime = endTime {
                UserDefaults.standard.set(endTime.timeIntervalSince1970, forKey: "workoutTimerEndTime")
                UserDefaults.standard.set(mode.rawValue, forKey: "workoutTimerMode")
                UserDefaults.standard.set(currentCycle, forKey: "workoutCurrentCycle")
                UserDefaults.standard.set(totalCycles, forKey: "workoutTotalCycles")
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
            NotificationManager.shared.scheduleWorkoutNotification(
                isExercise: mode == .exercise,
                fireDate: endTime
            )
        }

        #if canImport(ActivityKit)
        startLiveActivity(totalSeconds: totalTime, remaining: timeLeft)
        #endif

        // Start UI update timer
        timerSource = DispatchSource.makeTimerSource(queue: .main)
        timerSource?.schedule(deadline: .now(), repeating: 1.0)
        timerSource?.setEventHandler { [weak self] in
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
        timerSource?.resume()
    }

    private func pauseTimer() {
        timerSource?.cancel()
        timerSource = nil
        endTime = nil

        // Cancel scheduled notification
        NotificationManager.shared.cancelTimerNotification()

        #if canImport(ActivityKit)
        endLiveActivity()
        #endif
    }

    private func stopTimer() {
        timerSource?.cancel()
        timerSource = nil
        isRunning = false
        endTime = nil

        // Cancel scheduled notification
        NotificationManager.shared.cancelTimerNotification()

        #if canImport(ActivityKit)
        endLiveActivity()
        #endif
    }

    private func handleTimerComplete() {
        pauseTimer()

        // Play sound if enabled
        if settings.soundEnabled {
            SoundManager.shared.playCompletionSound()
        }

        if mode == .exercise {
            // Exercise completed - call callback
            onCycleComplete()

            // Switch to rest
            mode = .rest
            timeLeft = settings.restTime

            // Auto-start rest timer
            isRunning = true
            startTimer()
        } else {
            // Rest completed

            // Check if we completed all cycles
            if currentCycle >= totalCycles {
                // Workout complete!
                onWorkoutComplete()
                stopWorkout()
            } else {
                // Move to next cycle
                currentCycle += 1
                mode = .exercise
                timeLeft = settings.exerciseTime

                // Auto-start next exercise
                isRunning = true
                startTimer()
            }
        }
    }

    func formatTime(_ seconds: Int) -> String {
        seconds.formattedTime
    }

    func updateSettings(_ newSettings: WorkoutSettings) {
        // Don't update if timer is running
        guard !isRunning else { return }

        settings = newSettings

        // Reset current timer with new duration
        if !isWorkoutActive {
            timeLeft = settings.exerciseTime
        }
    }

    private func clearSavedState() {
        UserDefaults.standard.removeObject(forKey: "workoutTimerEndTime")
        UserDefaults.standard.removeObject(forKey: "workoutTimerMode")
        UserDefaults.standard.removeObject(forKey: "workoutCurrentCycle")
        UserDefaults.standard.removeObject(forKey: "workoutTotalCycles")
    }

#if canImport(ActivityKit)
    private func startLiveActivity(totalSeconds: Int, remaining: Int) {
        guard #available(iOS 16.1, *) else { return }
        WorkoutLiveActivityManager.shared.start(
            title: NSLocalizedString("app_title", comment: "App title"),
            mode: mode,
            currentCycle: currentCycle,
            totalCycles: totalCycles,
            totalSeconds: totalSeconds,
            remainingSeconds: remaining
        )
    }

    private func updateLiveActivity(remaining: Int) {
        guard #available(iOS 16.1, *) else { return }
        WorkoutLiveActivityManager.shared.update(
            mode: mode,
            currentCycle: currentCycle,
            totalCycles: totalCycles,
            totalSeconds: totalTime,
            remainingSeconds: remaining
        )
    }

    private func endLiveActivity() {
        guard #available(iOS 16.1, *) else { return }
        WorkoutLiveActivityManager.shared.end()
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
class WorkoutLiveActivityManager {
    static let shared = WorkoutLiveActivityManager()

    private var activity: Activity<TimerActivityAttributes>?

    func start(title: String, mode: WorkoutMode, currentCycle: Int, totalCycles: Int, totalSeconds: Int, remainingSeconds: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        // End previous activity if it exists
        if activity != nil {
            end()
        }

        let attributes = TimerActivityAttributes(title: title)
        let state = TimerActivityAttributes.ContentState(
            remainingSeconds: remainingSeconds,
            totalSeconds: totalSeconds,
            modeTitle: mode.localizedTitle,
            isWorkoutMode: true,
            currentCycle: currentCycle,
            totalCycles: totalCycles
        )

        do {
            let content = ActivityContent(
                state: state,
                staleDate: Date().addingTimeInterval(5)
            )
            activity = try Activity<TimerActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Failed to start workout live activity: \(error)")
        }
    }

    func update(mode: WorkoutMode, currentCycle: Int, totalCycles: Int, totalSeconds: Int, remainingSeconds: Int) {
        guard let activity else { return }
        let state = TimerActivityAttributes.ContentState(
            remainingSeconds: remainingSeconds,
            totalSeconds: totalSeconds,
            modeTitle: mode.localizedTitle,
            isWorkoutMode: true,
            currentCycle: currentCycle,
            totalCycles: totalCycles
        )

        ProcessInfo.processInfo.performExpiringActivity(withReason: "Workout Timer Update") { expired in
            guard !expired else { return }

            Task {
                let content = ActivityContent(
                    state: state,
                    staleDate: Date().addingTimeInterval(5)
                )
                await activity.update(content)
            }
        }
    }

    func end() {
        guard let activity else { return }
        Task {
            let content = ActivityContent(
                state: activity.content.state,
                staleDate: Date().addingTimeInterval(60)
            )
            await activity.end(content, dismissalPolicy: .immediate)
        }
        self.activity = nil
    }
}
#endif
