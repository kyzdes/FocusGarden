//
//  ContentView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showSettings = false
    @State private var showStatistics = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if showStatistics {
                StatisticsView(
                    progress: appViewModel.progress,
                    onClose: { showStatistics = false }
                )
            } else {
                mainContent
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                settings: $appViewModel.settings,
                workoutSettings: $appViewModel.workoutSettings,
                language: $appViewModel.language,
                theme: $appViewModel.theme,
                iCloudSyncEnabled: $appViewModel.iCloudSyncEnabled,
                getProgress: { appViewModel.progress },
                onImportProgress: { appViewModel.importProgress($0) },
                onClose: { showSettings = false }
            )
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(
                onSettingsClick: { showSettings = true },
                onStatisticsClick: { showStatistics = true }
            )

            ScrollView {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // iPad layout - side by side
                    HStack(alignment: .top, spacing: 24) {
                        leftSection
                        rightSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                } else {
                    // iPhone layout - stacked
                    VStack(spacing: 20) {
                        leftSection
                        rightSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
    }

    private var leftSection: some View {
        VStack(spacing: 20) {
            if appViewModel.appMode == .pomodoro {
                TimerView(viewModel: appViewModel.timerViewModel)
                ProgressTrackerView(progress: appViewModel.progress)
            } else {
                WorkoutTimerView(viewModel: appViewModel.workoutTimerViewModel)
                WorkoutProgressTrackerView(progress: appViewModel.workoutProgress)
            }
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : nil)
    }

    private var rightSection: some View {
        Group {
            if appViewModel.appMode == .pomodoro {
                GardenView(progress: appViewModel.progress)
            } else {
                GymView(progress: appViewModel.workoutProgress)
            }
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : nil)
    }
}

struct HeaderView: View {
    let onSettingsClick: () -> Void
    let onStatisticsClick: () -> Void
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey("app_title"))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)

                Text(LocalizedStringKey("app_subtitle"))
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            HStack(spacing: 12) {
                // Mode switcher
                Menu {
                    ForEach(AppMode.allCases, id: \.self) { mode in
                        Button {
                            if mode == .pomodoro {
                                appViewModel.switchToPomodoro()
                            } else {
                                appViewModel.switchToWorkout()
                            }
                        } label: {
                            HStack {
                                Text(mode.localizedTitle)
                                if appViewModel.appMode == mode {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: appViewModel.appMode == .pomodoro ? "leaf.fill" : "figure.run")
                        .font(.system(size: 20))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Color.backgroundCard.opacity(colorScheme == .dark ? 0.7 : 0.8))
                        .clipShape(Circle())
                }

                Button(action: onStatisticsClick) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Color.backgroundCard.opacity(colorScheme == .dark ? 0.7 : 0.8))
                        .clipShape(Circle())
                }

                Button(action: onSettingsClick) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Color.backgroundCard.opacity(colorScheme == .dark ? 0.7 : 0.8))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

private extension ContentView {
    var backgroundGradient: Gradient {
        if colorScheme == .dark {
            return Gradient(colors: [
                Color(red: 0.10, green: 0.11, blue: 0.12),
                Color(red: 0.13, green: 0.14, blue: 0.16),
                Color(red: 0.08, green: 0.11, blue: 0.12)
            ])
        } else {
            return Gradient(colors: [
                Color(red: 0.96, green: 0.95, blue: 0.94),
                Color(red: 0.98, green: 0.98, blue: 0.97),
                Color(red: 0.91, green: 0.96, blue: 0.94)
            ])
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
