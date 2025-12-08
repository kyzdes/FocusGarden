//
//  TimerState.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public struct TimerState: Codable, Equatable {
    // Common fields
    public let appMode: AppMode
    public let isRunning: Bool
    public let timeLeft: Int // in seconds
    public let progress: Double // 0.0 to 1.0

    // Pomodoro-specific
    public let timerMode: TimerMode?
    public let completedCycles: Int?

    // Workout-specific
    public let workoutMode: WorkoutMode?
    public let currentCycle: Int?
    public let totalCycles: Int?
    public let isWorkoutActive: Bool?

    // Timestamp for conflict resolution
    public let timestamp: Date

    public init(
        appMode: AppMode,
        isRunning: Bool,
        timeLeft: Int,
        progress: Double,
        timerMode: TimerMode? = nil,
        completedCycles: Int? = nil,
        workoutMode: WorkoutMode? = nil,
        currentCycle: Int? = nil,
        totalCycles: Int? = nil,
        isWorkoutActive: Bool? = nil,
        timestamp: Date = Date()
    ) {
        self.appMode = appMode
        self.isRunning = isRunning
        self.timeLeft = timeLeft
        self.progress = progress
        self.timerMode = timerMode
        self.completedCycles = completedCycles
        self.workoutMode = workoutMode
        self.currentCycle = currentCycle
        self.totalCycles = totalCycles
        self.isWorkoutActive = isWorkoutActive
        self.timestamp = timestamp
    }

    // Factory method for Pomodoro state
    public static func pomodoroState(
        isRunning: Bool,
        timeLeft: Int,
        progress: Double,
        mode: TimerMode,
        completedCycles: Int
    ) -> TimerState {
        TimerState(
            appMode: .pomodoro,
            isRunning: isRunning,
            timeLeft: timeLeft,
            progress: progress,
            timerMode: mode,
            completedCycles: completedCycles
        )
    }

    // Factory method for Workout state
    public static func workoutState(
        isRunning: Bool,
        timeLeft: Int,
        progress: Double,
        mode: WorkoutMode,
        currentCycle: Int,
        totalCycles: Int,
        isActive: Bool
    ) -> TimerState {
        TimerState(
            appMode: .workout,
            isRunning: isRunning,
            timeLeft: timeLeft,
            progress: progress,
            workoutMode: mode,
            currentCycle: currentCycle,
            totalCycles: totalCycles,
            isWorkoutActive: isActive
        )
    }
}
