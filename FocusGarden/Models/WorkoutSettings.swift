//
//  WorkoutSettings.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct WorkoutSettings: Codable, Equatable {
    var exerciseTime: Int // in seconds (30 - 600)
    var restTime: Int // in seconds (10 - 300)
    var soundEnabled: Bool

    static let `default` = WorkoutSettings(
        exerciseTime: 60, // seconds
        restTime: 30, // seconds
        soundEnabled: true
    )
}
