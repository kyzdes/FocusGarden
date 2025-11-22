//
//  Progress.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct Progress: Codable {
    var totalPomodoros: Int
    var todayPomodoros: Int
    var currentStreak: Int
    var trees: Int
    var clouds: Int
    var animals: [String]
    var history: [DailyRecord]

    static let empty = Progress(
        totalPomodoros: 0,
        todayPomodoros: 0,
        currentStreak: 0,
        trees: 0,
        clouds: 0,
        animals: [],
        history: []
    )
}

enum AnimalType: String, CaseIterable {
    case butterfly = "🦋"
    case bird = "🐦"
    case rabbit = "🐰"
    case deer = "🦌"
    case fox = "🦊"

    var milestone: Int {
        switch self {
        case .butterfly: return 3
        case .bird: return 7
        case .rabbit: return 15
        case .deer: return 25
        case .fox: return 40
        }
    }
}
