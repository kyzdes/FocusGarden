//
//  ContentView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showSettings = false
    @State private var showStatistics = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.96, green: 0.95, blue: 0.94),
                    Color(red: 0.98, green: 0.98, blue: 0.97),
                    Color(red: 0.91, green: 0.96, blue: 0.94)
                ]),
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
            TimerView(
                settings: appViewModel.settings,
                onComplete: { appViewModel.completedPomodoro() }
            )

            ProgressTrackerView(progress: appViewModel.progress)
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : nil)
    }

    private var rightSection: some View {
        GardenView(progress: appViewModel.progress)
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? .infinity : nil)
    }
}

struct HeaderView: View {
    let onSettingsClick: () -> Void
    let onStatisticsClick: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("🌱 Focus Garden")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)

                Text("Grow your productivity")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: onStatisticsClick) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }

                Button(action: onSettingsClick) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
