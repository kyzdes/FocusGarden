//
//  TimerSettings.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public struct TimerSettings: Codable, Equatable {
    public var focusTime: Int // in minutes
    public var breakTime: Int
    public var longBreakTime: Int
    public var soundEnabled: Bool

    public init(focusTime: Int, breakTime: Int, longBreakTime: Int, soundEnabled: Bool) {
        self.focusTime = focusTime
        self.breakTime = breakTime
        self.longBreakTime = longBreakTime
        self.soundEnabled = soundEnabled
    }

    public static let `default` = TimerSettings(
        focusTime: 25,
        breakTime: 5,
        longBreakTime: 15,
        soundEnabled: true
    )
}
