//
//  DailyChallenge.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum ChallengeType: String, Codable {
    case pomodoros = "Complete Pomodoros"
    case focusTime = "Focus Time"
    case streak = "Streak"
    case theme = "Theme"
    case sounds = "Sounds"
    case weekend = "Weekend"
}

struct DailyChallenge: Codable, Identifiable {
    let id: UUID
    let type: ChallengeType
    let title: String
    let description: String
    let icon: String
    let requirement: Int
    var currentProgress: Int
    let xpReward: Int
    let date: String // YYYY-MM-DD format

    var isCompleted: Bool {
        currentProgress >= requirement
    }

    var progressPercentage: Double {
        guard requirement > 0 else { return 0 }
        return min(Double(currentProgress) / Double(requirement), 1.0)
    }
}

extension DailyChallenge {
    static func generateDaily(for date: Date) -> [DailyChallenge] {
        let dateStr = date.toISODateString()
        let calendar = Calendar.current
        let isWeekend = calendar.isDateInWeekend(date)

        var challenges: [DailyChallenge] = [
            // Daily pomodoro challenge
            DailyChallenge(
                id: UUID(),
                type: .pomodoros,
                title: "Daily Focus",
                description: "Complete 4 Pomodoros today",
                icon: "🎯",
                requirement: 4,
                currentProgress: 0,
                xpReward: 50,
                date: dateStr
            ),

            // Focus time challenge
            DailyChallenge(
                id: UUID(),
                type: .focusTime,
                title: "Two Hour Club",
                description: "Focus for 2 hours total today",
                icon: "⏰",
                requirement: 120, // minutes
                currentProgress: 0,
                xpReward: 75,
                date: dateStr
            )
        ]

        // Weekend specific challenge
        if isWeekend {
            challenges.append(
                DailyChallenge(
                    id: UUID(),
                    type: .weekend,
                    title: "Weekend Warrior",
                    description: "Complete 3 sessions on the weekend",
                    icon: "🏋️",
                    requirement: 3,
                    currentProgress: 0,
                    xpReward: 100,
                    date: dateStr
                )
            )
        }

        return challenges
    }
}
