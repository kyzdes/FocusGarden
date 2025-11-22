//
//  TimerSettings.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct TimerSettings: Codable {
    var focusTime: Int // in minutes
    var breakTime: Int
    var longBreakTime: Int
    var soundEnabled: Bool

    static let `default` = TimerSettings(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        soundEnabled: true
    )
}
