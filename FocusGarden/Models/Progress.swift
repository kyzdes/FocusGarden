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
    var completedSessions: Int  // Session = Focus + Break
    var currentStreak: Int
    var trees: Int
    var clouds: Int
    var animals: [String]
    var history: [DailyRecord]

    // Custom decoding to handle old saved data without completedSessions field
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPomodoros = try container.decode(Int.self, forKey: .totalPomodoros)
        todayPomodoros = try container.decode(Int.self, forKey: .todayPomodoros)
        // Default to 0 if completedSessions doesn't exist in old data
        completedSessions = try container.decodeIfPresent(Int.self, forKey: .completedSessions) ?? 0
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        trees = try container.decode(Int.self, forKey: .trees)
        clouds = try container.decode(Int.self, forKey: .clouds)
        animals = try container.decode([String].self, forKey: .animals)
        history = try container.decode([DailyRecord].self, forKey: .history)
    }

    // Regular init
    init(totalPomodoros: Int, todayPomodoros: Int, completedSessions: Int, currentStreak: Int, trees: Int, clouds: Int, animals: [String], history: [DailyRecord]) {
        self.totalPomodoros = totalPomodoros
        self.todayPomodoros = todayPomodoros
        self.completedSessions = completedSessions
        self.currentStreak = currentStreak
        self.trees = trees
        self.clouds = clouds
        self.animals = animals
        self.history = history
    }

    static let empty = Progress(
        totalPomodoros: 0,
        todayPomodoros: 0,
        completedSessions: 0,
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
