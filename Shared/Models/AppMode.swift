//
//  AppMode.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public enum AppMode: String, Codable, CaseIterable {
    case pomodoro = "Pomodoro"
    case workout = "Workout"

    public var localizedTitle: String {
        switch self {
        case .pomodoro:
            return NSLocalizedString("mode_pomodoro", comment: "Pomodoro mode")
        case .workout:
            return NSLocalizedString("mode_workout", comment: "Workout mode")
        }
    }

    public var icon: String {
        switch self {
        case .pomodoro:
            return "leaf.fill"
        case .workout:
            return "figure.run"
        }
    }
}
