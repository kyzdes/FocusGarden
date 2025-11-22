//
//  StorageManager.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

class StorageManager {
    static let shared = StorageManager()

    private let settingsKey = "focusGardenSettings"
    private let progressKey = "focusGardenProgress"
    private let lastDateKey = "focusGardenLastDate"

    private init() {}

    // MARK: - Settings

    func saveSettings(_ settings: TimerSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    func loadSettings() -> TimerSettings {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(TimerSettings.self, from: data) else {
            return .default
        }
        return settings
    }

    // MARK: - Progress

    func saveProgress(_ progress: Progress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }

    func loadProgress() -> Progress {
        guard let data = UserDefaults.standard.data(forKey: progressKey),
              let progress = try? JSONDecoder().decode(Progress.self, from: data) else {
            return .empty
        }
        return progress
    }

    // MARK: - Last Completion Date

    func saveLastDate(_ date: String) {
        UserDefaults.standard.set(date, forKey: lastDateKey)
    }

    func loadLastDate() -> String? {
        return UserDefaults.standard.string(forKey: lastDateKey)
    }

    // MARK: - Reset

    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: settingsKey)
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.removeObject(forKey: lastDateKey)
    }
}
