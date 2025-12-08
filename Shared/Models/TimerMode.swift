//
//  TimerMode.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public enum TimerMode: String, Codable, CaseIterable {
    case focus = "Focus Time"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    public var localizedTitle: String {
        switch self {
        case .focus:
            return NSLocalizedString("focus_time", comment: "Focus mode title")
        case .shortBreak:
            return NSLocalizedString("short_break", comment: "Short break mode title")
        case .longBreak:
            return NSLocalizedString("long_break", comment: "Long break mode title")
        }
    }

    public var color: String {
        switch self {
        case .focus: return "FocusColor"
        case .shortBreak: return "BreakColor"
        case .longBreak: return "LongBreakColor"
        }
    }
}
