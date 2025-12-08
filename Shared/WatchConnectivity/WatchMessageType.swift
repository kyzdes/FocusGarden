//
//  WatchMessageType.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public enum WatchMessageType: String, Codable {
    // iPhone → Watch messages
    case timerStateUpdate = "timerStateUpdate"
    case settingsUpdate = "settingsUpdate"
    case progressUpdate = "progressUpdate"

    // Watch → iPhone commands
    case startTimer = "startTimer"
    case pauseTimer = "pauseTimer"
    case resumeTimer = "resumeTimer"
    case resetTimer = "resetTimer"
    case switchMode = "switchMode"
    case switchAppMode = "switchAppMode"

    // Workout-specific
    case startWorkout = "startWorkout"
    case stopWorkout = "stopWorkout"

    // Bidirectional
    case requestSync = "requestSync"
    case syncComplete = "syncComplete"
}
