//
//  WatchMessage.swift
//  FocusGarden Shared
//
//  Created by Claude
//

import Foundation

public struct WatchMessage: Codable {
    public let type: WatchMessageType
    public let payload: Data?
    public let timestamp: Date

    public init(type: WatchMessageType, payload: Data? = nil, timestamp: Date = Date()) {
        self.type = type
        self.payload = payload
        self.timestamp = timestamp
    }

    // Helper methods for encoding typed payloads
    public static func timerState(_ state: TimerState) -> WatchMessage {
        let payload = try? JSONEncoder().encode(state)
        return WatchMessage(type: .timerStateUpdate, payload: payload)
    }

    public static func settingsUpdate(timer: TimerSettings?, workout: WorkoutSettings?) -> WatchMessage {
        let settings = SettingsPayload(timer: timer, workout: workout)
        let payload = try? JSONEncoder().encode(settings)
        return WatchMessage(type: .settingsUpdate, payload: payload)
    }

    public static func progressUpdate(todayCount: Int, streak: Int) -> WatchMessage {
        let progress = ProgressPayload(todayPomodoros: todayCount, currentStreak: streak)
        let payload = try? JSONEncoder().encode(progress)
        return WatchMessage(type: .progressUpdate, payload: payload)
    }

    public static func command(_ type: WatchMessageType, data: [String: Any]? = nil) -> WatchMessage {
        var payload: Data?
        if let data = data {
            payload = try? JSONSerialization.data(withJSONObject: data)
        }
        return WatchMessage(type: type, payload: payload)
    }

    public static func simple(_ type: WatchMessageType) -> WatchMessage {
        WatchMessage(type: type, payload: nil)
    }

    // Decode payload to specific type
    public func decode<T: Decodable>() -> T? {
        guard let payload = payload else { return nil }
        return try? JSONDecoder().decode(T.self, from: payload)
    }

    // Convert to dictionary for WatchConnectivity
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "type": type.rawValue,
            "timestamp": timestamp.timeIntervalSince1970
        ]
        if let payload = payload {
            dict["payload"] = payload
        }
        return dict
    }

    // Create from dictionary received via WatchConnectivity
    public static func fromDictionary(_ dict: [String: Any]) -> WatchMessage? {
        guard let typeString = dict["type"] as? String,
              let type = WatchMessageType(rawValue: typeString),
              let timestampInterval = dict["timestamp"] as? TimeInterval else {
            return nil
        }

        let payload = dict["payload"] as? Data
        let timestamp = Date(timeIntervalSince1970: timestampInterval)

        return WatchMessage(type: type, payload: payload, timestamp: timestamp)
    }
}

// Supporting payload structures
public struct SettingsPayload: Codable {
    public let timer: TimerSettings?
    public let workout: WorkoutSettings?

    public init(timer: TimerSettings?, workout: WorkoutSettings?) {
        self.timer = timer
        self.workout = workout
    }
}

public struct ProgressPayload: Codable {
    public let todayPomodoros: Int
    public let currentStreak: Int

    public init(todayPomodoros: Int, currentStreak: Int) {
        self.todayPomodoros = todayPomodoros
        self.currentStreak = currentStreak
    }
}
