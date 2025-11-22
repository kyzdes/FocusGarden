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

    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.settings = storageManager.loadSettings()
        self.progress = storageManager.loadProgress()
        self.lastCompletionDate = storageManager.loadLastDate()

        // Reset today's count if it's a new day
        let today = Date().toDateString()
        if lastCompletionDate != today {
            progress.todayPomodoros = 0
        }

        setupObservers()
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
                self?.storageManager.saveProgress(progress)
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

        // Update streak
        if lastCompletionDate == yesterday || lastCompletionDate == today {
            progress.currentStreak += 1
        } else {
            progress.currentStreak = 1
        }

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

    func resetAllData() {
        progress = .empty
        settings = .default
        lastCompletionDate = nil
        storageManager.resetAllData()
    }
}
