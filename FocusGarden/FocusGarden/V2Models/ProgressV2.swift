//
//  ProgressV2.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

struct ProgressV2: Codable {
    // V1 Data (preserved for backward compatibility)
    var totalPomodoros: Int
    var todayPomodoros: Int
    var currentStreak: Int
    var trees: Int
    var clouds: Int
    var animals: [String]
    var history: [DailyRecord]

    // V2 New Data
    var userLevel: UserLevel
    var achievements: [UserAchievement]
    var tasks: [FocusTask]
    var dailyChallenges: [DailyChallenge]
    var completedActivities: [UUID] // IDs of completed break activities
    var favoriteQuotes: [UUID]
    var currentGardenTheme: GardenTheme
    var unlockedThemes: [GardenTheme]
    var customPresets: [TimerPreset]
    var selectedPreset: UUID?
    var totalFocusMinutes: Int
    var consecutiveSessionsCount: Int // For perfectionist achievement
    var lastSessionDate: Date?

    // Statistics
    var bestProductivityHour: Int? // Hour of day (0-23)
    var totalSessionsCompleted: Int
    var totalSessionsSkipped: Int

    static let empty = ProgressV2(
        totalPomodoros: 0,
        todayPomodoros: 0,
        currentStreak: 0,
        trees: 0,
        clouds: 0,
        animals: [],
        history: [],
        userLevel: UserLevel(),
        achievements: Achievement.all.map { UserAchievement(achievementId: $0.id, progress: 0, unlockedDate: nil) },
        tasks: [],
        dailyChallenges: [],
        completedActivities: [],
        favoriteQuotes: [],
        currentGardenTheme: .zenGarden,
        unlockedThemes: [.zenGarden],
        customPresets: [],
        selectedPreset: nil,
        totalFocusMinutes: 0,
        consecutiveSessionsCount: 0,
        lastSessionDate: nil,
        bestProductivityHour: nil,
        totalSessionsCompleted: 0,
        totalSessionsSkipped: 0
    )

    // Migrate from V1 Progress
    static func migrate(from v1: Progress) -> ProgressV2 {
        var v2 = ProgressV2.empty
        v2.totalPomodoros = v1.totalPomodoros
        v2.todayPomodoros = v1.todayPomodoros
        v2.currentStreak = v1.currentStreak
        v2.trees = v1.trees
        v2.clouds = v1.clouds
        v2.animals = v1.animals
        v2.history = v1.history

        // Calculate total focus minutes from history
        v2.totalFocusMinutes = v1.history.reduce(0) { $0 + $1.focusMinutes }
        v2.totalSessionsCompleted = v1.totalPomodoros

        return v2
    }

    // Check and unlock achievements
    mutating func checkAchievements() -> [Achievement] {
        var newlyUnlocked: [Achievement] = []

        for achievement in Achievement.all {
            guard let index = achievements.firstIndex(where: { $0.achievementId == achievement.id }) else { continue }

            // Skip if already unlocked
            if achievements[index].isUnlocked { continue }

            var shouldUnlock = false

            switch achievement.id {
            // Milestones
            case "first_bloom", "getting_started", "focused_10", "quarter_century",
                 "half_century", "centurion", "master_500":
                shouldUnlock = totalPomodoros >= achievement.requirement

            // Streaks
            case "two_day_streak", "week_streak", "two_week_streak", "month_streak":
                shouldUnlock = currentStreak >= achievement.requirement

            // Focus time
            case "focused_10h", "focused_50h", "focused_100h":
                shouldUnlock = totalFocusMinutes >= achievement.requirement

            // Exploration
            case "theme_explorer":
                shouldUnlock = unlockedThemes.count >= achievement.requirement
            case "garden_master":
                shouldUnlock = unlockedThemes.count >= 4

            // Dedication
            case "perfectionist":
                shouldUnlock = consecutiveSessionsCount >= achievement.requirement

            default:
                break
            }

            if shouldUnlock {
                achievements[index].progress = achievement.requirement
                achievements[index].unlockedDate = Date()
                newlyUnlocked.append(achievement)
            }
        }

        return newlyUnlocked
    }

    // Update daily challenges
    mutating func updateChallenges(pomodorosCompleted: Int, focusMinutes: Int) {
        let today = Date().toISODateString()

        // Generate new challenges if needed
        if dailyChallenges.isEmpty || dailyChallenges.first?.date != today {
            dailyChallenges = DailyChallenge.generateDaily(for: Date())
        }

        // Update progress
        for i in 0..<dailyChallenges.count {
            switch dailyChallenges[i].type {
            case .pomodoros:
                dailyChallenges[i].currentProgress = todayPomodoros
            case .focusTime:
                dailyChallenges[i].currentProgress = focusMinutes
            default:
                break
            }
        }
    }

    // Award XP and check for level up
    mutating func awardXP(_ amount: Int) -> Bool {
        return userLevel.addXP(amount)
    }
}
