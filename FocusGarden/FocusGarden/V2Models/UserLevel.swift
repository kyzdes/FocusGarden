//
//  UserLevel.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

struct UserLevel: Codable {
    var currentLevel: Int
    var currentXP: Int
    var totalXP: Int

    init(currentLevel: Int = 1, currentXP: Int = 0, totalXP: Int = 0) {
        self.currentLevel = currentLevel
        self.currentXP = currentXP
        self.totalXP = totalXP
    }

    // XP needed for next level (exponential growth)
    var xpForNextLevel: Int {
        return 100 * currentLevel
    }

    var progressToNextLevel: Double {
        guard xpForNextLevel > 0 else { return 0 }
        return Double(currentXP) / Double(xpForNextLevel)
    }

    mutating func addXP(_ amount: Int) -> Bool {
        currentXP += amount
        totalXP += amount

        // Check if leveled up
        if currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            currentLevel += 1
            return true // Level up!
        }

        return false
    }

    var levelTitle: String {
        switch currentLevel {
        case 1...5: return "Novice Focuser"
        case 6...10: return "Apprentice"
        case 11...20: return "Focused Worker"
        case 21...30: return "Productivity Expert"
        case 31...40: return "Focus Master"
        case 41...50: return "Zen Master"
        case 51...75: return "Legendary Focuser"
        case 76...99: return "Productivity Sage"
        default: return "Ultimate Focus Champion"
        }
    }
}
