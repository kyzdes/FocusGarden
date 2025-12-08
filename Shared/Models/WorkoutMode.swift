//
//  WorkoutMode.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public enum WorkoutMode: String, Codable, CaseIterable {
    case exercise = "Exercise"
    case rest = "Rest"

    public var localizedTitle: String {
        switch self {
        case .exercise:
            return NSLocalizedString("exercise_time", comment: "Exercise mode title")
        case .rest:
            return NSLocalizedString("rest_time", comment: "Rest mode title")
        }
    }

    public var color: String {
        switch self {
        case .exercise:
            return "ExerciseOrange"
        case .rest:
            return "RestBlue"
        }
    }
}
