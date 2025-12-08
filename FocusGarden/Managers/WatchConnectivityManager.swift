//
//  WatchConnectivityManager.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    private var session: WCSession?

    // Callbacks for handling Watch commands
    var onStartTimer: (() -> Void)?
    var onPauseTimer: (() -> Void)?
    var onResumeTimer: (() -> Void)?
    var onResetTimer: (() -> Void)?
    var onSwitchMode: ((TimerMode) -> Void)?
    var onSwitchAppMode: ((AppMode) -> Void)?
    var onStartWorkout: ((Int) -> Void)? // cycles parameter
    var onStopWorkout: (() -> Void)?

    private override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        guard WCSession.isSupported() else {
            print("WatchConnectivity not supported on this device")
            return
        }

        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    // MARK: - Send Updates to Watch

    func sendTimerState(_ state: TimerState) {
        guard let session = session, session.isReachable else {
            // Watch not reachable, save to App Groups for later
            saveTimerStateToAppGroups(state)
            return
        }

        let message = WatchMessage.timerState(state)
        sendMessage(message)
    }

    func sendSettingsUpdate(timer: TimerSettings?, workout: WorkoutSettings?) {
        guard let session = session, session.isReachable else {
            saveSettingsToAppGroups(timer: timer, workout: workout)
            return
        }

        let message = WatchMessage.settingsUpdate(timer: timer, workout: workout)
        sendMessage(message)
    }

    func sendProgressUpdate(todayCount: Int, streak: Int) {
        guard let session = session, session.isReachable else {
            saveProgressToAppGroups(todayCount: todayCount, streak: streak)
            return
        }

        let message = WatchMessage.progressUpdate(todayCount: todayCount, streak: streak)
        sendMessage(message)
    }

    private func sendMessage(_ message: WatchMessage) {
        guard let session = session, session.isReachable else { return }

        let dict = message.toDictionary()
        session.sendMessage(dict, replyHandler: nil) { error in
            print("Failed to send message to Watch: \\(error.localizedDescription)")
            // Fallback: save to App Groups
            self.handleMessageFailure(message)
        }
    }

    private func handleMessageFailure(_ message: WatchMessage) {
        // Save failed messages to App Groups as fallback
        switch message.type {
        case .timerStateUpdate:
            if let state: TimerState = message.decode() {
                saveTimerStateToAppGroups(state)
            }
        case .settingsUpdate:
            if let settings: SettingsPayload = message.decode() {
                saveSettingsToAppGroups(timer: settings.timer, workout: settings.workout)
            }
        case .progressUpdate:
            if let progress: ProgressPayload = message.decode() {
                saveProgressToAppGroups(todayCount: progress.todayPomodoros, streak: progress.currentStreak)
            }
        default:
            break
        }
    }

    // MARK: - App Groups Fallback

    private func saveTimerStateToAppGroups(_ state: TimerState) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.focusgarden.app") else { return }
        if let data = try? JSONEncoder().encode(state) {
            sharedDefaults.set(data, forKey: "timerState")
        }
    }

    private func saveSettingsToAppGroups(timer: TimerSettings?, workout: WorkoutSettings?) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.focusgarden.app") else { return }

        if let timer = timer, let data = try? JSONEncoder().encode(timer) {
            sharedDefaults.set(data, forKey: "timerSettings")
        }
        if let workout = workout, let data = try? JSONEncoder().encode(workout) {
            sharedDefaults.set(data, forKey: "workoutSettings")
        }
    }

    private func saveProgressToAppGroups(todayCount: Int, streak: Int) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.focusgarden.app") else { return }
        sharedDefaults.set(todayCount, forKey: "todayPomodoros")
        sharedDefaults.set(streak, forKey: "currentStreak")
    }

    // MARK: - Handle Incoming Commands from Watch

    private func handleCommand(_ message: WatchMessage) {
        switch message.type {
        case .startTimer:
            onStartTimer?()
        case .pauseTimer:
            onPauseTimer?()
        case .resumeTimer:
            onResumeTimer?()
        case .resetTimer:
            onResetTimer?()
        case .switchMode:
            if let payload = message.payload,
               let dict = try? JSONSerialization.jsonObject(with: payload) as? [String: String],
               let modeString = dict["mode"],
               let mode = TimerMode(rawValue: modeString) {
                onSwitchMode?(mode)
            }
        case .switchAppMode:
            if let payload = message.payload,
               let dict = try? JSONSerialization.jsonObject(with: payload) as? [String: String],
               let modeString = dict["mode"],
               let mode = AppMode(rawValue: modeString) {
                onSwitchAppMode?(mode)
            }
        case .startWorkout:
            if let payload = message.payload,
               let dict = try? JSONSerialization.jsonObject(with: payload) as? [String: Int],
               let cycles = dict["cycles"] {
                onStartWorkout?(cycles)
            }
        case .stopWorkout:
            onStopWorkout?()
        case .requestSync:
            // Watch is requesting full sync - will be handled by AppViewModel
            NotificationCenter.default.post(name: .watchRequestedSync, object: nil)
        default:
            break
        }
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \\(error.localizedDescription)")
            return
        }

        print("WCSession activated with state: \\(activationState.rawValue)")

        // When session activates, trigger a full sync
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .watchSessionActivated, object: nil)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated - reactivating")
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard let watchMessage = WatchMessage.fromDictionary(message) else {
            print("Failed to decode message from Watch")
            return
        }

        DispatchQueue.main.async {
            self.handleCommand(watchMessage)
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let watchMessage = WatchMessage.fromDictionary(message) else {
            replyHandler(["error": "Invalid message format"])
            return
        }

        DispatchQueue.main.async {
            self.handleCommand(watchMessage)
            replyHandler(["status": "received"])
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let watchSessionActivated = Notification.Name("watchSessionActivated")
    static let watchRequestedSync = Notification.Name("watchRequestedSync")
}
