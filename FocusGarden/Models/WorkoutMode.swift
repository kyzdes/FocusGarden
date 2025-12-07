//
//  WorkoutMode.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

enum WorkoutMode: String, CaseIterable {
    case exercise = "Exercise"
    case rest = "Rest"

    var localizedTitle: String {
        switch self {
        case .exercise:
            return NSLocalizedString("exercise_time", comment: "Exercise mode title")
        case .rest:
            return NSLocalizedString("rest_time", comment: "Rest mode title")
        }
    }

    var color: String {
        switch self {
        case .exercise:
            return "ExerciseOrange"
        case .rest:
            return "RestBlue"
        }
    }

    var gradientColors: (String, String) {
        switch self {
        case .exercise:
            return ("ExerciseOrange", "ExerciseOrangeDark")
        case .rest:
            return ("RestBlue", "RestBlueDark")
        }
    }
}
