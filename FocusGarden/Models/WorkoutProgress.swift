//
//  WorkoutProgress.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct WorkoutProgress: Codable, Equatable {
    var totalCycles: Int
    var todayCycles: Int
    var completedWorkouts: Int
    var currentStreak: Int
    var dumbbells: Int // каждый цикл
    var kettlebells: Int // каждые 2 цикла
    var equipment: [String] // milestone rewards
    var history: [WorkoutRecord]

    init(totalCycles: Int, todayCycles: Int, completedWorkouts: Int, currentStreak: Int,
         dumbbells: Int, kettlebells: Int, equipment: [String], history: [WorkoutRecord]) {
        self.totalCycles = totalCycles
        self.todayCycles = todayCycles
        self.completedWorkouts = completedWorkouts
        self.currentStreak = currentStreak
        self.dumbbells = dumbbells
        self.kettlebells = kettlebells
        self.equipment = equipment
        self.history = history
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCycles = try container.decode(Int.self, forKey: .totalCycles)
        todayCycles = try container.decode(Int.self, forKey: .todayCycles)
        completedWorkouts = try container.decodeIfPresent(Int.self, forKey: .completedWorkouts) ?? 0
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        dumbbells = try container.decode(Int.self, forKey: .dumbbells)
        kettlebells = try container.decode(Int.self, forKey: .kettlebells)
        equipment = try container.decode([String].self, forKey: .equipment)
        history = try container.decode([WorkoutRecord].self, forKey: .history)
    }

    static let empty = WorkoutProgress(
        totalCycles: 0,
        todayCycles: 0,
        completedWorkouts: 0,
        currentStreak: 0,
        dumbbells: 0,
        kettlebells: 0,
        equipment: [],
        history: []
    )
}

// Типы инвентаря с milestone требованиями
enum EquipmentType: String, CaseIterable {
    case jumprope = "jumprope"
    case mat = "mat"
    case barbell = "barbell"
    case bike = "bike"
    case boxing = "boxing"

    var emoji: String {
        switch self {
        case .jumprope: return "🪢"
        case .mat: return "🧘"
        case .barbell: return "🏋️"
        case .bike: return "🚴"
        case .boxing: return "🥊"
        }
    }

    var milestone: Int {
        switch self {
        case .jumprope: return 5
        case .mat: return 10
        case .barbell: return 20
        case .bike: return 35
        case .boxing: return 50
        }
    }
}
