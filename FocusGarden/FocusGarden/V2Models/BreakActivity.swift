//
//  BreakActivity.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum ActivityCategory: String, Codable, CaseIterable {
    case physical = "Physical"
    case eyeCare = "Eye Care"
    case mental = "Mental"
    case hydration = "Hydration"
    case social = "Social"

    var icon: String {
        switch self {
        case .physical: return "🤸"
        case .eyeCare: return "👀"
        case .mental: return "🧘"
        case .hydration: return "💧"
        case .social: return "💬"
        }
    }
}

struct BreakActivity: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let category: ActivityCategory
    let duration: Int // in minutes
    let icon: String
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: ActivityCategory,
        duration: Int,
        icon: String,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.duration = duration
        self.icon = icon
        self.isFavorite = isFavorite
    }
}

extension BreakActivity {
    static let activities: [BreakActivity] = [
        // Physical
        BreakActivity(
            title: "Stretch Routine",
            description: "Stand up and stretch your arms, legs, and back",
            category: .physical,
            duration: 5,
            icon: "🤸"
        ),
        BreakActivity(
            title: "Quick Walk",
            description: "Take a short walk around your space",
            category: .physical,
            duration: 5,
            icon: "🚶"
        ),
        BreakActivity(
            title: "Desk Exercises",
            description: "Do simple exercises at your desk",
            category: .physical,
            duration: 5,
            icon: "💪"
        ),
        BreakActivity(
            title: "Yoga Poses",
            description: "Try 3-5 simple yoga poses",
            category: .physical,
            duration: 10,
            icon: "🧘"
        ),

        // Eye Care
        BreakActivity(
            title: "20-20-20 Rule",
            description: "Look at something 20 feet away for 20 seconds",
            category: .eyeCare,
            duration: 1,
            icon: "👁️"
        ),
        BreakActivity(
            title: "Eye Exercises",
            description: "Do eye rolls and focus shifts",
            category: .eyeCare,
            duration: 3,
            icon: "👀"
        ),
        BreakActivity(
            title: "Look Outside",
            description: "Gaze at distant objects outside",
            category: .eyeCare,
            duration: 2,
            icon: "🌅"
        ),

        // Mental
        BreakActivity(
            title: "Deep Breathing",
            description: "Practice deep breathing exercises",
            category: .mental,
            duration: 5,
            icon: "🫁"
        ),
        BreakActivity(
            title: "Quick Meditation",
            description: "1-minute mindfulness meditation",
            category: .mental,
            duration: 1,
            icon: "🧘"
        ),
        BreakActivity(
            title: "Gratitude Moment",
            description: "Think of 3 things you're grateful for",
            category: .mental,
            duration: 2,
            icon: "💭"
        ),
        BreakActivity(
            title: "Listen to Music",
            description: "Listen to your favorite calming song",
            category: .mental,
            duration: 5,
            icon: "🎵"
        ),

        // Hydration
        BreakActivity(
            title: "Drink Water",
            description: "Drink a full glass of water",
            category: .hydration,
            duration: 1,
            icon: "💧"
        ),
        BreakActivity(
            title: "Healthy Snack",
            description: "Have a healthy snack",
            category: .hydration,
            duration: 5,
            icon: "🍎"
        ),
        BreakActivity(
            title: "Tea Break",
            description: "Make and enjoy a cup of tea",
            category: .hydration,
            duration: 10,
            icon: "🍵"
        ),

        // Social
        BreakActivity(
            title: "Quick Chat",
            description: "Chat with a colleague or friend",
            category: .social,
            duration: 5,
            icon: "💬"
        ),
        BreakActivity(
            title: "Send a Message",
            description: "Send a nice message to someone",
            category: .social,
            duration: 2,
            icon: "📱"
        )
    ]

    static func suggestActivities(for breakDuration: Int, count: Int = 3) -> [BreakActivity] {
        let suitable = activities.filter { $0.duration <= breakDuration }
        return Array(suitable.shuffled().prefix(count))
    }
}
