//
//  TimerPreset.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

struct TimerPreset: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var icon: String
    var focusTime: Int
    var breakTime: Int
    var longBreakTime: Int
    var cyclesBeforeLongBreak: Int
    var isCustom: Bool

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        focusTime: Int,
        breakTime: Int,
        longBreakTime: Int,
        cyclesBeforeLongBreak: Int = 4,
        isCustom: Bool = false
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.focusTime = focusTime
        self.breakTime = breakTime
        self.longBreakTime = longBreakTime
        self.cyclesBeforeLongBreak = cyclesBeforeLongBreak
        self.isCustom = isCustom
    }
}

extension TimerPreset {
    static let presets: [TimerPreset] = [
        TimerPreset(
            name: "Classic Pomodoro",
            icon: "🎯",
            focusTime: 25,
            breakTime: 5,
            longBreakTime: 15
        ),
        TimerPreset(
            name: "Power Hour",
            icon: "🚀",
            focusTime: 50,
            breakTime: 10,
            longBreakTime: 20
        ),
        TimerPreset(
            name: "Quick Sprint",
            icon: "⚡",
            focusTime: 15,
            breakTime: 3,
            longBreakTime: 10
        ),
        TimerPreset(
            name: "Study Session",
            icon: "📚",
            focusTime: 45,
            breakTime: 15,
            longBreakTime: 30
        ),
        TimerPreset(
            name: "Creative Flow",
            icon: "🎨",
            focusTime: 90,
            breakTime: 20,
            longBreakTime: 30
        ),
        TimerPreset(
            name: "Micro Task",
            icon: "💡",
            focusTime: 10,
            breakTime: 2,
            longBreakTime: 5
        )
    ]
}
