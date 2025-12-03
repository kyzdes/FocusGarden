//
//  StorageManager.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import CloudKit

class StorageManager {
    static let shared = StorageManager()

    private let settingsKey = "focusGardenSettings"
    private let progressKey = "focusGardenProgress"
    private let lastDateKey = "focusGardenLastDate"
    private let languageKey = "focusGardenLanguage"
    private let themeKey = "focusGardenTheme"
    private let iCloudSyncKey = "focusGardenICloudSyncEnabled"
    private let ubiquitousStore = NSUbiquitousKeyValueStore.default

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

    // MARK: - Language

    func saveLanguage(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
    }

    func loadLanguage() -> AppLanguage {
        if let value = UserDefaults.standard.string(forKey: languageKey),
           let language = AppLanguage(rawValue: value) {
            return language
        }
        return .english
    }

    // MARK: - Theme

    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }

    func loadTheme() -> AppTheme {
        if let value = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: value) {
            return theme
        }
        return .system
    }

    // MARK: - iCloud Sync

    func saveICloudEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: iCloudSyncKey)
    }

    func loadICloudEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: iCloudSyncKey) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: iCloudSyncKey)
    }

    func saveProgressToCloud(_ progress: Progress) {
        guard let encoded = try? JSONEncoder().encode(progress) else { return }
        ubiquitousStore.set(encoded, forKey: progressKey)
        ubiquitousStore.synchronize()
    }

    func loadProgressFromCloud() -> Progress? {
        guard let data = ubiquitousStore.data(forKey: progressKey) else { return nil }
        return try? JSONDecoder().decode(Progress.self, from: data)
    }

    func clearCloudProgress() {
        ubiquitousStore.removeObject(forKey: progressKey)
        ubiquitousStore.synchronize()
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
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: themeKey)
        UserDefaults.standard.removeObject(forKey: iCloudSyncKey)
    }
}
