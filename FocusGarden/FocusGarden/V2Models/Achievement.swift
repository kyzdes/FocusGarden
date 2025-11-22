//
//  Achievement.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum AchievementRarity: String, Codable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"

    var emoji: String {
        switch self {
        case .common: return "🥉"
        case .rare: return "🥈"
        case .epic: return "🥇"
        case .legendary: return "💎"
        }
    }
}

struct Achievement: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let icon: String // SF Symbol or emoji
    let rarity: AchievementRarity
    let requirement: Int // Number needed to unlock
    let category: AchievementCategory

    enum AchievementCategory: String, Codable {
        case milestones = "Milestones"
        case streaks = "Streaks"
        case timing = "Timing"
        case exploration = "Exploration"
        case dedication = "Dedication"
    }
}

struct UserAchievement: Codable {
    let achievementId: String
    var progress: Int
    var unlockedDate: Date?
    var isUnlocked: Bool {
        unlockedDate != nil
    }
}

// Predefined achievements
extension Achievement {
    static let all: [Achievement] = [
        // Milestones
        Achievement(
            id: "first_bloom",
            title: "First Bloom",
            description: "Complete your first Pomodoro session",
            icon: "🌱",
            rarity: .common,
            requirement: 1,
            category: .milestones
        ),
        Achievement(
            id: "getting_started",
            title: "Getting Started",
            description: "Complete 5 Pomodoro sessions",
            icon: "🌿",
            rarity: .common,
            requirement: 5,
            category: .milestones
        ),
        Achievement(
            id: "focused_10",
            title: "Decade",
            description: "Complete 10 Pomodoro sessions",
            icon: "🍃",
            rarity: .common,
            requirement: 10,
            category: .milestones
        ),
        Achievement(
            id: "quarter_century",
            title: "Quarter Century",
            description: "Complete 25 Pomodoro sessions",
            icon: "🌳",
            rarity: .rare,
            requirement: 25,
            category: .milestones
        ),
        Achievement(
            id: "half_century",
            title: "Half Century",
            description: "Complete 50 Pomodoro sessions",
            icon: "🌲",
            rarity: .rare,
            requirement: 50,
            category: .milestones
        ),
        Achievement(
            id: "centurion",
            title: "Centurion",
            description: "Complete 100 Pomodoro sessions",
            icon: "💯",
            rarity: .epic,
            requirement: 100,
            category: .milestones
        ),
        Achievement(
            id: "master_500",
            title: "Focus Master",
            description: "Complete 500 Pomodoro sessions",
            icon: "⭐",
            rarity: .legendary,
            requirement: 500,
            category: .milestones
        ),

        // Streaks
        Achievement(
            id: "two_day_streak",
            title: "Building Habits",
            description: "Maintain a 2-day streak",
            icon: "🔥",
            rarity: .common,
            requirement: 2,
            category: .streaks
        ),
        Achievement(
            id: "week_streak",
            title: "On Fire",
            description: "Maintain a 7-day streak",
            icon: "🔥",
            rarity: .rare,
            requirement: 7,
            category: .streaks
        ),
        Achievement(
            id: "two_week_streak",
            title: "Unstoppable",
            description: "Maintain a 14-day streak",
            icon: "🔥",
            rarity: .epic,
            requirement: 14,
            category: .streaks
        ),
        Achievement(
            id: "month_streak",
            title: "Consistency King",
            description: "Maintain a 30-day streak",
            icon: "👑",
            rarity: .legendary,
            requirement: 30,
            category: .streaks
        ),

        // Timing
        Achievement(
            id: "early_bird",
            title: "Early Bird",
            description: "Complete a session before 7am",
            icon: "🌅",
            rarity: .rare,
            requirement: 1,
            category: .timing
        ),
        Achievement(
            id: "night_owl",
            title: "Night Owl",
            description: "Complete a session after 10pm",
            icon: "🌙",
            rarity: .rare,
            requirement: 1,
            category: .timing
        ),
        Achievement(
            id: "weekend_warrior",
            title: "Weekend Warrior",
            description: "Complete 3 sessions on a weekend",
            icon: "🎯",
            rarity: .rare,
            requirement: 3,
            category: .timing
        ),
        Achievement(
            id: "marathon",
            title: "Marathon",
            description: "Complete 12 sessions in one day",
            icon: "🏃",
            rarity: .epic,
            requirement: 12,
            category: .timing
        ),

        // Exploration
        Achievement(
            id: "theme_explorer",
            title: "Theme Explorer",
            description: "Try all garden themes",
            icon: "🎨",
            rarity: .rare,
            requirement: 4,
            category: .exploration
        ),
        Achievement(
            id: "garden_master",
            title: "Garden Master",
            description: "Unlock all garden themes",
            icon: "🌺",
            rarity: .epic,
            requirement: 4,
            category: .exploration
        ),
        Achievement(
            id: "sound_master",
            title: "Sound Master",
            description: "Try all ambient sounds",
            icon: "🎵",
            rarity: .rare,
            requirement: 9,
            category: .exploration
        ),

        // Dedication
        Achievement(
            id: "focused_10h",
            title: "10 Hour Club",
            description: "Focus for 10 hours total",
            icon: "⏰",
            rarity: .rare,
            requirement: 600, // in minutes
            category: .dedication
        ),
        Achievement(
            id: "focused_50h",
            title: "Scholar",
            description: "Focus for 50 hours total",
            icon: "📚",
            rarity: .epic,
            requirement: 3000,
            category: .dedication
        ),
        Achievement(
            id: "focused_100h",
            title: "Master Scholar",
            description: "Focus for 100 hours total",
            icon: "🎓",
            rarity: .legendary,
            requirement: 6000,
            category: .dedication
        ),
        Achievement(
            id: "perfectionist",
            title: "Perfectionist",
            description: "Complete 10 sessions without skipping",
            icon: "✨",
            rarity: .epic,
            requirement: 10,
            category: .dedication
        ),
    ]
}
