//
//  WorkoutSettings.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public struct WorkoutSettings: Codable, Equatable {
    public var exerciseTime: Int // in seconds (30 - 600)
    public var restTime: Int // in seconds (10 - 300)
    public var soundEnabled: Bool

    public init(exerciseTime: Int, restTime: Int, soundEnabled: Bool) {
        self.exerciseTime = exerciseTime
        self.restTime = restTime
        self.soundEnabled = soundEnabled
    }

    public static let `default` = WorkoutSettings(
        exerciseTime: 60, // seconds
        restTime: 30, // seconds
        soundEnabled: true
    )
}
