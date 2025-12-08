//
//  PomodoroTimerView.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import SwiftUI

struct PomodoroTimerView: View {
    @EnvironmentObject var viewModel: WatchViewModel

    var body: some View {
        VStack(spacing: 8) {
            // Mode indicator
            Text(viewModel.currentTimerMode.localizedTitle)
                .font(.caption)
                .foregroundColor(modeColor.opacity(0.8))

            // Timer circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(modeColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: viewModel.progress)

                VStack(spacing: 4) {
                    Text(viewModel.formatTime(viewModel.timeLeft))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text("Cycle \\(viewModel.completedCycles + 1)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            // Control buttons
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.toggleTimer()
                    WKInterfaceDevice.current().play(.click)
                }) {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(viewModel.isRunning ? Color.red : modeColor)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(action: {
                    viewModel.resetTimer()
                    WKInterfaceDevice.current().play(.click)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // Mode selector (only when not running)
            if !viewModel.isRunning {
                Picker("Mode", selection: Binding(
                    get: { viewModel.currentTimerMode },
                    set: { viewModel.switchMode($0) }
                )) {
                    ForEach(TimerMode.allCases, id: \\.self) { mode in
                        Text(mode.localizedTitle.prefix(5))
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }
        .padding()
    }

    private var modeColor: Color {
        switch viewModel.currentTimerMode {
        case .focus:
            return Color.green
        case .shortBreak:
            return Color.blue
        case .longBreak:
            return Color.purple
        }
    }
}

#Preview {
    PomodoroTimerView()
        .environmentObject(WatchViewModel())
}
