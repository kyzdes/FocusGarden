//
//  Task.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum TaskCategory: String, Codable, CaseIterable {
    case work = "Work"
    case study = "Study"
    case creative = "Creative"
    case personal = "Personal"
    case home = "Home"
    case custom = "Custom"

    var icon: String {
        switch self {
        case .work: return "💼"
        case .study: return "📚"
        case .creative: return "🎨"
        case .personal: return "💪"
        case .home: return "🏠"
        case .custom: return "📌"
        }
    }

    var colorName: String {
        switch self {
        case .work: return "blue"
        case .study: return "purple"
        case .creative: return "pink"
        case .personal: return "green"
        case .home: return "orange"
        case .custom: return "gray"
        }
    }
}

enum TaskPriority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3

    var label: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }

    var icon: String {
        switch self {
        case .low: return "⬇️"
        case .medium: return "➡️"
        case .high: return "⬆️"
        case .urgent: return "🔴"
        }
    }
}

struct FocusTask: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var notes: String?
    var category: TaskCategory
    var priority: TaskPriority
    var estimatedPomodoros: Int
    var completedPomodoros: Int
    var isCompleted: Bool
    var createdDate: Date
    var completedDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        category: TaskCategory = .work,
        priority: TaskPriority = .medium,
        estimatedPomodoros: Int = 1,
        completedPomodoros: Int = 0,
        isCompleted: Bool = false,
        createdDate: Date = Date(),
        completedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.category = category
        self.priority = priority
        self.estimatedPomodoros = estimatedPomodoros
        self.completedPomodoros = completedPomodoros
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.completedDate = completedDate
    }

    var progressPercentage: Double {
        guard estimatedPomodoros > 0 else { return 0 }
        return Double(completedPomodoros) / Double(estimatedPomodoros)
    }
}
