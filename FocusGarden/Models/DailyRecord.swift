//
//  DailyRecord.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct DailyRecord: Codable, Identifiable {
    let id: UUID
    let date: String // ISO date format (yyyy-MM-dd)
    var pomodoros: Int
    var focusMinutes: Int

    init(id: UUID = UUID(), date: String, pomodoros: Int, focusMinutes: Int) {
        self.id = id
        self.date = date
        self.pomodoros = pomodoros
        self.focusMinutes = focusMinutes
    }
}
