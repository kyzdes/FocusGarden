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

    // Workout keys
    private let workoutSettingsKey = "focusGardenWorkoutSettings"
    private let workoutProgressKey = "focusGardenWorkoutProgress"
    private let lastWorkoutDateKey = "focusGardenLastWorkoutDate"
    private let appModeKey = "focusGardenAppMode"

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
        return .russian
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

    // MARK: - Workout Settings

    func saveWorkoutSettings(_ settings: WorkoutSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: workoutSettingsKey)
        }
    }

    func loadWorkoutSettings() -> WorkoutSettings {
        guard let data = UserDefaults.standard.data(forKey: workoutSettingsKey),
              let settings = try? JSONDecoder().decode(WorkoutSettings.self, from: data) else {
            return .default
        }
        return settings
    }

    // MARK: - Workout Progress

    func saveWorkoutProgress(_ progress: WorkoutProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: workoutProgressKey)
        }
    }

    func loadWorkoutProgress() -> WorkoutProgress {
        guard let data = UserDefaults.standard.data(forKey: workoutProgressKey),
              let progress = try? JSONDecoder().decode(WorkoutProgress.self, from: data) else {
            return .empty
        }
        return progress
    }

    // MARK: - App Mode

    func saveAppMode(_ mode: AppMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: appModeKey)
    }

    func loadAppMode() -> AppMode {
        if let value = UserDefaults.standard.string(forKey: appModeKey),
           let mode = AppMode(rawValue: value) {
            return mode
        }
        return .pomodoro
    }

    // MARK: - Last Workout Date

    func saveLastWorkoutDate(_ date: String) {
        UserDefaults.standard.set(date, forKey: lastWorkoutDateKey)
    }

    func loadLastWorkoutDate() -> String? {
        return UserDefaults.standard.string(forKey: lastWorkoutDateKey)
    }

    // MARK: - Workout iCloud Sync

    func saveWorkoutProgressToCloud(_ progress: WorkoutProgress) {
        guard let encoded = try? JSONEncoder().encode(progress) else { return }
        ubiquitousStore.set(encoded, forKey: workoutProgressKey)
        ubiquitousStore.synchronize()
    }

    func loadWorkoutProgressFromCloud() -> WorkoutProgress? {
        guard let data = ubiquitousStore.data(forKey: workoutProgressKey) else { return nil }
        return try? JSONDecoder().decode(WorkoutProgress.self, from: data)
    }

    func clearCloudWorkoutProgress() {
        ubiquitousStore.removeObject(forKey: workoutProgressKey)
        ubiquitousStore.synchronize()
    }

    // MARK: - Reset

    func resetAllData() {
        // Pomodoro data
        UserDefaults.standard.removeObject(forKey: settingsKey)
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.removeObject(forKey: lastDateKey)

        // Workout data
        UserDefaults.standard.removeObject(forKey: workoutSettingsKey)
        UserDefaults.standard.removeObject(forKey: workoutProgressKey)
        UserDefaults.standard.removeObject(forKey: lastWorkoutDateKey)
        UserDefaults.standard.removeObject(forKey: appModeKey)

        // App settings
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: themeKey)
        UserDefaults.standard.removeObject(forKey: iCloudSyncKey)
    }
}
