//
//  AppMode.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

enum AppMode: String, Codable, CaseIterable {
    case pomodoro = "Pomodoro"
    case workout = "Workout"

    var localizedTitle: String {
        switch self {
        case .pomodoro:
            return NSLocalizedString("mode_pomodoro", comment: "Pomodoro mode")
        case .workout:
            return NSLocalizedString("mode_workout", comment: "Workout mode")
        }
    }

    var icon: String {
        switch self {
        case .pomodoro:
            return "leaf.fill"
        case .workout:
            return "figure.run"
        }
    }
}
