//
//  ContentView.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WatchViewModel

    var body: some View {
        TabView {
            // Timer view (Pomodoro or Workout based on mode)
            timerView
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            // Progress view
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
        }
        .tabViewStyle(.page)
    }

    @ViewBuilder
    private var timerView: View {
        VStack(spacing: 0) {
            // Connection status
            if !viewModel.isConnected {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
                        .font(.caption2)
                    Text("Offline")
                        .font(.caption2)
                }
                .foregroundColor(.orange)
                .padding(.top, 4)
            }

            // Mode switcher
            Picker("Mode", selection: Binding(
                get: { viewModel.appMode },
                set: { viewModel.switchAppMode($0) }
            )) {
                ForEach(AppMode.allCases, id: \\.self) { mode in
                    Label(mode.localizedTitle, systemImage: mode.icon)
                        .tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .disabled(viewModel.isRunning)
            .padding(.horizontal)
            .padding(.top, viewModel.isConnected ? 0 : 4)

            // Timer content
            if viewModel.appMode == .pomodoro {
                PomodoroTimerView()
            } else {
                WorkoutTimerView()
            }
        }
    }
}

struct ProgressView: View {
    @EnvironmentObject var viewModel: WatchViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Today's Progress")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 12) {
                    StatRow(
                        icon: "leaf.fill",
                        label: "Pomodoros",
                        value: "\\(viewModel.todayPomodoros)"
                    )

                    StatRow(
                        icon: "flame.fill",
                        label: "Streak",
                        value: "\\(viewModel.currentStreak) days"
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

                Button(action: {
                    viewModel.requestSync()
                    WKInterfaceDevice.current().play(.click)
                }) {
                    Label("Sync", systemImage: "arrow.triangle.2.circlepath")
                        .font(.footnote)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)

            Text(label)
                .font(.footnote)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchViewModel())
}
