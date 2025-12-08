//
//  WatchViewModel.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import Foundation
import Combine

class WatchViewModel: ObservableObject {
    @Published var appMode: AppMode = .pomodoro
    @Published var timerState: TimerState?
    @Published var timerSettings: TimerSettings = .default
    @Published var workoutSettings: WorkoutSettings = .default
    @Published var todayPomodoros: Int = 0
    @Published var currentStreak: Int = 0
    @Published var isConnected: Bool = false

    private let connectivityManager = WatchConnectivityManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        requestSync()
    }

    private func setupBindings() {
        // Observe connectivity manager updates
        connectivityManager.$timerState
            .receive(on: DispatchQueue.main)
            .assign(to: &$timerState)

        connectivityManager.$timerSettings
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: &$timerSettings)

        connectivityManager.$workoutSettings
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: &$workoutSettings)

        connectivityManager.$todayPomodoros
            .receive(on: DispatchQueue.main)
            .assign(to: &$todayPomodoros)

        connectivityManager.$currentStreak
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentStreak)

        connectivityManager.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)

        // Update appMode when timer state changes
        connectivityManager.$timerState
            .receive(on: DispatchQueue.main)
            .compactMap { $0?.appMode }
            .assign(to: &$appMode)
    }

    // MARK: - Actions

    func requestSync() {
        connectivityManager.requestSync()
    }

    func toggleTimer() {
        guard let state = timerState else { return }

        if state.isRunning {
            connectivityManager.pauseTimer()
        } else {
            if state.timeLeft == (currentTimerDuration * 60) && state.appMode == .pomodoro {
                // Timer is at start, treat as start
                connectivityManager.startTimer()
            } else if state.timeLeft == currentTimerDuration && state.appMode == .workout {
                // Workout timer at start
                connectivityManager.startTimer()
            } else {
                // Timer is paused, resume
                connectivityManager.resumeTimer()
            }
        }
    }

    func resetTimer() {
        connectivityManager.resetTimer()
    }

    func switchMode(_ mode: TimerMode) {
        connectivityManager.switchMode(mode)
    }

    func switchAppMode(_ mode: AppMode) {
        connectivityManager.switchAppMode(mode)
    }

    func startWorkout(cycles: Int) {
        connectivityManager.startWorkout(cycles: cycles)
    }

    func stopWorkout() {
        connectivityManager.stopWorkout()
    }

    // MARK: - Computed Properties

    var isRunning: Bool {
        timerState?.isRunning ?? false
    }

    var timeLeft: Int {
        timerState?.timeLeft ?? 0
    }

    var progress: Double {
        timerState?.progress ?? 0
    }

    var currentTimerMode: TimerMode {
        timerState?.timerMode ?? .focus
    }

    var currentWorkoutMode: WorkoutMode {
        timerState?.workoutMode ?? .exercise
    }

    var completedCycles: Int {
        timerState?.completedCycles ?? 0
    }

    var currentCycle: Int {
        timerState?.currentCycle ?? 1
    }

    var totalCycles: Int {
        timerState?.totalCycles ?? 3
    }

    var isWorkoutActive: Bool {
        timerState?.isWorkoutActive ?? false
    }

    var currentTimerDuration: Int {
        if appMode == .pomodoro {
            switch currentTimerMode {
            case .focus:
                return timerSettings.focusTime
            case .shortBreak:
                return timerSettings.breakTime
            case .longBreak:
                return timerSettings.longBreakTime
            }
        } else {
            switch currentWorkoutMode {
            case .exercise:
                return workoutSettings.exerciseTime
            case .rest:
                return workoutSettings.restTime
            }
        }
    }

    // MARK: - Helpers

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
