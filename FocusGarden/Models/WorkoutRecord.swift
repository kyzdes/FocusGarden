//
//  WorkoutRecord.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

struct WorkoutRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let date: String // ISO date format
    var cycles: Int
    var exerciseMinutes: Int

    init(id: UUID = UUID(), date: String, cycles: Int, exerciseMinutes: Int) {
        self.id = id
        self.date = date
        self.cycles = cycles
        self.exerciseMinutes = exerciseMinutes
    }
}
