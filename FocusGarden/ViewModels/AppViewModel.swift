//
//  AppViewModel.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import Combine

class AppViewModel: ObservableObject {
    // Pomodoro state
    @Published var settings: TimerSettings
    @Published var progress: Progress
    @Published var lastCompletionDate: String?

    // Workout state
    @Published var appMode: AppMode
    @Published var workoutSettings: WorkoutSettings
    @Published var workoutProgress: WorkoutProgress
    @Published var lastWorkoutDate: String?

    // App settings
    @Published var language: AppLanguage
    @Published var theme: AppTheme
    @Published var iCloudSyncEnabled: Bool

    // Timer ViewModels - live at app level to persist across navigation
    var timerViewModel: TimerViewModel!
    var workoutTimerViewModel: WorkoutTimerViewModel!

    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var cloudObserver: NSObjectProtocol?

    init() {
        // Load Pomodoro state
        self.settings = storageManager.loadSettings()
        self.progress = storageManager.loadProgress()
        self.lastCompletionDate = storageManager.loadLastDate()

        // Load Workout state
        self.appMode = storageManager.loadAppMode()
        self.workoutSettings = storageManager.loadWorkoutSettings()
        self.workoutProgress = storageManager.loadWorkoutProgress()
        self.lastWorkoutDate = storageManager.loadLastWorkoutDate()

        // Load App settings
        self.language = storageManager.loadLanguage()
        self.theme = storageManager.loadTheme()
        self.iCloudSyncEnabled = storageManager.loadICloudEnabled()

        // Reset today's count if it's a new day
        let today = Date().toDateString()
        if lastCompletionDate != today {
            progress.todayPomodoros = 0
        }
        if lastWorkoutDate != today {
            workoutProgress.todayCycles = 0
        }

        // Initialize timer view models after settings are loaded
        self.timerViewModel = TimerViewModel(
            settings: settings,
            onFocusComplete: { [weak self] in self?.completedPomodoro() },
            onBreakComplete: { [weak self] in self?.completedBreak() }
        )

        self.workoutTimerViewModel = WorkoutTimerViewModel(
            settings: workoutSettings,
            onCycleComplete: { [weak self] in self?.completedWorkoutCycle() },
            onWorkoutComplete: { [weak self] in self?.completedWorkout() }
        )

        setupObservers()
        setupCloudSync()
    }

    private func setupObservers() {
        // Save settings whenever they change
        $settings
            .dropFirst()
            .sink { [weak self] settings in
                guard let self else { return }
                self.storageManager.saveSettings(settings)
                self.timerViewModel.updateSettings(settings)
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
                    self.storageManager.saveWorkoutProgressToCloud(self.workoutProgress)
                    NSUbiquitousKeyValueStore.default.synchronize()
                }
            }
            .store(in: &cancellables)

        // Save workout settings whenever they change
        $workoutSettings
            .dropFirst()
            .sink { [weak self] settings in
                guard let self else { return }
                self.storageManager.saveWorkoutSettings(settings)
                self.workoutTimerViewModel.updateSettings(settings)
            }
            .store(in: &cancellables)

        // Save workout progress whenever it changes
        $workoutProgress
            .dropFirst()
            .sink { [weak self] progress in
                guard let self else { return }
                self.storageManager.saveWorkoutProgress(progress)
                if self.iCloudSyncEnabled {
                    self.storageManager.saveWorkoutProgressToCloud(progress)
                }
            }
            .store(in: &cancellables)

        // Save app mode whenever it changes
        $appMode
            .dropFirst()
            .sink { [weak self] mode in
                self?.storageManager.saveAppMode(mode)
            }
            .store(in: &cancellables)
    }

    func completedPomodoro() {
        let today = Date().toDateString()
        let todayISO = Date().toISODateString()

        // Update progress
        progress.totalPomodoros += 1
        progress.todayPomodoros += 1

        // Update streak
        updateStreak(lastDate: lastCompletionDate, today: today, streak: &progress.currentStreak)

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
        for animalType in AnimalType.allCases {
            if progress.totalPomodoros == animalType.milestone &&
               !progress.animals.contains(animalType.rawValue) {
                progress.animals.append(animalType.rawValue)
            }
        }
    }

    func completedBreak() {
        // Increment completed sessions (Focus + Break = 1 session)
        progress.completedSessions += 1
    }

    // MARK: - Workout Methods

    func completedWorkoutCycle() {
        let today = Date().toDateString()
        let todayISO = Date().toISODateString()

        // Update progress
        workoutProgress.totalCycles += 1
        workoutProgress.todayCycles += 1

        // Update history
        if let index = workoutProgress.history.firstIndex(where: { $0.date == todayISO }) {
            workoutProgress.history[index].cycles += 1
            workoutProgress.history[index].exerciseMinutes += workoutSettings.exerciseTime / 60
        } else {
            let newRecord = WorkoutRecord(
                date: todayISO,
                cycles: 1,
                exerciseMinutes: workoutSettings.exerciseTime / 60
            )
            workoutProgress.history.append(newRecord)
        }

        // Add dumbbells every cycle
        workoutProgress.dumbbells += 1

        // Add kettlebells every 2 cycles
        if workoutProgress.totalCycles % 2 == 0 {
            workoutProgress.kettlebells += 1
        }

        // Unlock equipment at milestones
        unlockEquipment()

        // Play sound if enabled
        if workoutSettings.soundEnabled {
            SoundManager.shared.playCompletionSound()
        }
    }

    func completedWorkout() {
        let today = Date().toDateString()

        workoutProgress.completedWorkouts += 1

        // Update streak
        updateStreak(lastDate: lastWorkoutDate, today: today, streak: &workoutProgress.currentStreak)

        // Save last workout date
        lastWorkoutDate = today
        storageManager.saveLastWorkoutDate(today)
    }

    private func unlockEquipment() {
        for equipmentType in EquipmentType.allCases {
            if workoutProgress.totalCycles == equipmentType.milestone &&
               !workoutProgress.equipment.contains(equipmentType.rawValue) {
                workoutProgress.equipment.append(equipmentType.rawValue)
            }
        }
    }

    private func updateStreak(lastDate: String?, today: String, streak: inout Int) {
        guard lastDate != today else { return }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.toDateString()
        streak = (lastDate == yesterday) ? streak + 1 : 1
    }

    func switchToPomodoro() {
        appMode = .pomodoro
    }

    func switchToWorkout() {
        appMode = .workout
    }

    func resetAllData() {
        // Reset Pomodoro data
        progress = .empty
        settings = .default
        lastCompletionDate = nil

        // Reset Workout data
        workoutProgress = .empty
        workoutSettings = .default
        lastWorkoutDate = nil
        appMode = .pomodoro

        // Reset App settings
        language = .english
        theme = .system
        iCloudSyncEnabled = storageManager.loadICloudEnabled()

        // Clear storage
        storageManager.resetAllData()
        storageManager.clearCloudProgress()
        storageManager.clearCloudWorkoutProgress()
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

    func importWorkoutProgress(_ newProgress: WorkoutProgress) {
        workoutProgress = newProgress
        lastWorkoutDate = newProgress.todayCycles > 0 ? Date().toDateString() : nil
        storageManager.saveWorkoutProgress(newProgress)
        if iCloudSyncEnabled {
            storageManager.saveWorkoutProgressToCloud(newProgress)
        }
        if let lastDate = lastWorkoutDate {
            storageManager.saveLastWorkoutDate(lastDate)
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
                // Sync Pomodoro progress
                if let cloudProgress = self.storageManager.loadProgressFromCloud(),
                   cloudProgress != self.progress {
                    self.progress = cloudProgress
                }

                // Sync Workout progress
                if let cloudWorkoutProgress = self.storageManager.loadWorkoutProgressFromCloud(),
                   cloudWorkoutProgress != self.workoutProgress {
                    self.workoutProgress = cloudWorkoutProgress
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
