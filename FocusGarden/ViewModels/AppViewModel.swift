//
//  AppViewModel.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var settings: TimerSettings
    @Published var progress: Progress
    @Published var lastCompletionDate: String?
    @Published var language: AppLanguage
    @Published var theme: AppTheme
    @Published var iCloudSyncEnabled: Bool

    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var cloudObserver: NSObjectProtocol?

    init() {
        self.settings = storageManager.loadSettings()
        self.progress = storageManager.loadProgress()
        self.lastCompletionDate = storageManager.loadLastDate()
        self.language = storageManager.loadLanguage()
        self.theme = storageManager.loadTheme()
        self.iCloudSyncEnabled = storageManager.loadICloudEnabled()

        // Reset today's count if it's a new day
        let today = Date().toDateString()
        if lastCompletionDate != today {
            progress.todayPomodoros = 0
        }

        setupObservers()
        setupCloudSync()
    }

    private func setupObservers() {
        // Save settings whenever they change
        $settings
            .dropFirst()
            .sink { [weak self] settings in
                self?.storageManager.saveSettings(settings)
            }
            .store(in: &cancellables)

        // Save progress whenever it changes
        $progress
            .dropFirst()
            .sink { [weak self] progress in
                guard let self else { return }
                self.storageManager.saveProgress(progress)
                if self.iCloudSyncEnabled {
                    self.storageManager.saveProgressToCloud(progress)
                }
            }
            .store(in: &cancellables)

        // Save language whenever it changes
        $language
            .dropFirst()
            .sink { [weak self] language in
                self?.storageManager.saveLanguage(language)
            }
            .store(in: &cancellables)

        // Save theme whenever it changes
        $theme
            .dropFirst()
            .sink { [weak self] theme in
                self?.storageManager.saveTheme(theme)
            }
            .store(in: &cancellables)

        // Save iCloud preference
        $iCloudSyncEnabled
            .dropFirst()
            .sink { [weak self] enabled in
                guard let self else { return }
                self.storageManager.saveICloudEnabled(enabled)
                if enabled {
                    self.storageManager.saveProgressToCloud(self.progress)
                    NSUbiquitousKeyValueStore.default.synchronize()
                }
            }
            .store(in: &cancellables)
    }

    func completedPomodoro() {
        let today = Date().toDateString()
        let todayISO = Date().toISODateString()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.toDateString()

        // Update progress
        progress.totalPomodoros += 1
        progress.todayPomodoros += 1

        // Update streak - only update if this is the first pomodoro of the day
        if lastCompletionDate != today {
            if lastCompletionDate == yesterday {
                // Continue streak
                progress.currentStreak += 1
            } else {
                // Start new streak
                progress.currentStreak = 1
            }
        }
        // If lastCompletionDate == today, streak already updated, do nothing

        // Update history
        if let index = progress.history.firstIndex(where: { $0.date == todayISO }) {
            progress.history[index].pomodoros += 1
            progress.history[index].focusMinutes += settings.focusTime
        } else {
            let newRecord = DailyRecord(
                date: todayISO,
                pomodoros: 1,
                focusMinutes: settings.focusTime
            )
            progress.history.append(newRecord)
        }

        // Add trees every pomodoro
        progress.trees += 1

        // Add clouds every 2 pomodoros
        if progress.totalPomodoros % 2 == 0 {
            progress.clouds += 1
        }

        // Unlock animals at milestones
        unlockAnimals()

        // Save last completion date
        lastCompletionDate = today
        storageManager.saveLastDate(today)

        // Play sound if enabled
        if settings.soundEnabled {
            SoundManager.shared.playCompletionSound()
        }
    }

    private func unlockAnimals() {
        let milestones: [(count: Int, animal: String)] = [
            (3, "butterfly"),
            (7, "bird"),
            (15, "rabbit"),
            (25, "deer"),
            (40, "fox")
        ]

        for milestone in milestones {
            if progress.totalPomodoros == milestone.count &&
               !progress.animals.contains(milestone.animal) {
                progress.animals.append(milestone.animal)
            }
        }
    }

    func completedBreak() {
        // Increment completed sessions (Focus + Break = 1 session)
        progress.completedSessions += 1
    }

    func resetAllData() {
        progress = .empty
        settings = .default
        lastCompletionDate = nil
        language = .english
        theme = .system
        iCloudSyncEnabled = storageManager.loadICloudEnabled()
        storageManager.resetAllData()
        storageManager.clearCloudProgress()
    }

    func importProgress(_ newProgress: Progress) {
        progress = newProgress
        lastCompletionDate = newProgress.todayPomodoros > 0 ? Date().toDateString() : nil
        storageManager.saveProgress(newProgress)
        if iCloudSyncEnabled {
            storageManager.saveProgressToCloud(newProgress)
        }
        if let lastDate = lastCompletionDate {
            storageManager.saveLastDate(lastDate)
        }
    }

    private func setupCloudSync() {
        NSUbiquitousKeyValueStore.default.synchronize()

        cloudObserver = NotificationCenter.default.addObserver(
            forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, self.iCloudSyncEnabled else { return }
            Task { @MainActor in
                guard let cloudProgress = self.storageManager.loadProgressFromCloud() else { return }
                if cloudProgress != self.progress {
                    self.progress = cloudProgress
                }
            }
        }
    }

    deinit {
        if let cloudObserver {
            NotificationCenter.default.removeObserver(cloudObserver)
        }
    }
}
