//
//  TimerViewModel.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation
import Combine

enum TimerMode: String, CaseIterable {
    case focus = "Focus Time"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var color: String {
        switch self {
        case .focus: return "FocusColor"
        case .shortBreak: return "BreakColor"
        case .longBreak: return "LongBreakColor"
        }
    }

    var gradientColors: (String, String) {
        switch self {
        case .focus: return ("FocusGradient1", "FocusGradient2")
        case .shortBreak: return ("BreakGradient1", "BreakGradient2")
        case .longBreak: return ("LongBreakGradient1", "LongBreakGradient2")
        }
    }
}

class TimerViewModel: ObservableObject {
    @Published var mode: TimerMode = .focus
    @Published var timeLeft: Int = 0
    @Published var isRunning: Bool = false
    @Published var completedCycles: Int = 0

    var settings: TimerSettings
    var onComplete: () -> Void

    private var timer: Timer?
    private var totalTime: Int {
        switch mode {
        case .focus:
            return settings.focusTime * 60
        case .shortBreak:
            return settings.breakTime * 60
        case .longBreak:
            return settings.longBreakTime * 60
        }
    }

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalTime - timeLeft) / Double(totalTime)
    }

    init(settings: TimerSettings, onComplete: @escaping () -> Void) {
        self.settings = settings
        self.onComplete = onComplete
        self.timeLeft = settings.focusTime * 60
    }

    func toggleTimer() {
        isRunning.toggle()

        if isRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }

    func resetTimer() {
        stopTimer()
        timeLeft = totalTime
    }

    func switchMode(_ newMode: TimerMode) {
        guard !isRunning else { return }

        mode = newMode
        timeLeft = totalTime
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                self.handleTimerComplete()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func handleTimerComplete() {
        stopTimer()

        if mode == .focus {
            completedCycles += 1
            onComplete()

            // Switch to break mode
            if completedCycles % 4 == 0 {
                mode = .longBreak
                timeLeft = settings.longBreakTime * 60
            } else {
                mode = .shortBreak
                timeLeft = settings.breakTime * 60
            }
        } else {
            // Switch back to focus mode
            mode = .focus
            timeLeft = settings.focusTime * 60
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    deinit {
        stopTimer()
    }
}
