//
//  WatchConnectivityManager.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var timerState: TimerState?
    @Published var timerSettings: TimerSettings?
    @Published var workoutSettings: WorkoutSettings?
    @Published var todayPomodoros: Int = 0
    @Published var currentStreak: Int = 0
    @Published var isConnected: Bool = false

    private var session: WCSession?

    private override init() {
        super.init()
        setupSession()
        loadFromAppGroups()
    }

    private func setupSession() {
        guard WCSession.isSupported() else {
            print("WatchConnectivity not supported")
            return
        }

        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    // MARK: - Send Commands to iPhone

    func sendCommand(_ type: WatchMessageType, data: [String: Any]? = nil) {
        guard let session = session else { return }

        let message = WatchMessage.command(type, data: data)
        let dict = message.toDictionary()

        if session.isReachable {
            session.sendMessage(dict, replyHandler: nil) { error in
                print("Failed to send command to iPhone: \\(error.localizedDescription)")
            }
        } else {
            print("iPhone not reachable - command not sent: \\(type.rawValue)")
        }
    }

    func requestSync() {
        sendCommand(.requestSync)
    }

    func startTimer() {
        sendCommand(.startTimer)
    }

    func pauseTimer() {
        sendCommand(.pauseTimer)
    }

    func resumeTimer() {
        sendCommand(.resumeTimer)
    }

    func resetTimer() {
        sendCommand(.resetTimer)
    }

    func switchMode(_ mode: TimerMode) {
        sendCommand(.switchMode, data: ["mode": mode.rawValue])
    }

    func switchAppMode(_ mode: AppMode) {
        sendCommand(.switchAppMode, data: ["mode": mode.rawValue])
    }

    func startWorkout(cycles: Int) {
        sendCommand(.startWorkout, data: ["cycles": cycles])
    }

    func stopWorkout() {
        sendCommand(.stopWorkout)
    }

    // MARK: - Load from App Groups (Fallback)

    private func loadFromAppGroups() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.focusgarden.app") else { return }

        // Load timer state
        if let data = sharedDefaults.data(forKey: "timerState"),
           let state = try? JSONDecoder().decode(TimerState.self, from: data) {
            DispatchQueue.main.async {
                self.timerState = state
            }
        }

        // Load settings
        if let data = sharedDefaults.data(forKey: "timerSettings"),
           let settings = try? JSONDecoder().decode(TimerSettings.self, from: data) {
            DispatchQueue.main.async {
                self.timerSettings = settings
            }
        }

        if let data = sharedDefaults.data(forKey: "workoutSettings"),
           let settings = try? JSONDecoder().decode(WorkoutSettings.self, from: data) {
            DispatchQueue.main.async {
                self.workoutSettings = settings
            }
        }

        // Load progress
        let todayCount = sharedDefaults.integer(forKey: "todayPomodoros")
        let streak = sharedDefaults.integer(forKey: "currentStreak")

        DispatchQueue.main.async {
            self.todayPomodoros = todayCount
            self.currentStreak = streak
        }
    }

    // MARK: - Handle Updates from iPhone

    private func handleUpdate(_ message: WatchMessage) {
        switch message.type {
        case .timerStateUpdate:
            if let state: TimerState = message.decode() {
                DispatchQueue.main.async {
                    self.timerState = state
                }
            }

        case .settingsUpdate:
            if let settings: SettingsPayload = message.decode() {
                DispatchQueue.main.async {
                    if let timer = settings.timer {
                        self.timerSettings = timer
                    }
                    if let workout = settings.workout {
                        self.workoutSettings = workout
                    }
                }
            }

        case .progressUpdate:
            if let progress: ProgressPayload = message.decode() {
                DispatchQueue.main.async {
                    self.todayPomodoros = progress.todayPomodoros
                    self.currentStreak = progress.currentStreak
                }
            }

        case .syncComplete:
            print("Sync completed with iPhone")

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

        DispatchQueue.main.async {
            self.isConnected = session.isReachable

            // Request sync when session activates
            if self.isConnected {
                self.requestSync()
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = session.isReachable
            print("iPhone reachability changed: \\(session.isReachable)")

            // Request sync when iPhone becomes reachable
            if session.isReachable {
                self.requestSync()
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard let watchMessage = WatchMessage.fromDictionary(message) else {
            print("Failed to decode message from iPhone")
            return
        }

        handleUpdate(watchMessage)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        guard let watchMessage = WatchMessage.fromDictionary(message) else {
            replyHandler(["error": "Invalid message format"])
            return
        }

        handleUpdate(watchMessage)
        replyHandler(["status": "received"])
    }
}
