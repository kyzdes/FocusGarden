//
//  LandscapeWorkoutTimerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct LandscapeWorkoutTimerView: View {
    @ObservedObject var viewModel: WorkoutTimerViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showCycleSelector = false

    var body: some View {
        HStack(spacing: 40) {
            // Left: Mode indicator (vertical, non-interactive)
            VStack(spacing: 16) {
                ForEach(WorkoutMode.allCases, id: \.self) { mode in
                    LandscapeWorkoutModeIndicator(
                        mode: mode,
                        isSelected: viewModel.mode == mode
                    )
                }
            }
            .frame(width: 180)

            // Center: Timer circle + cycle progress
            VStack(spacing: 20) {
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.gray.opacity(colorScheme == .dark ? 0.25 : 0.1), lineWidth: 14)
                        .frame(width: 260, height: 260)

                    // Progress circle
                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(
                            viewModel.mode.modeColor,
                            style: StrokeStyle(lineWidth: 14, lineCap: .round)
                        )
                        .frame(width: 260, height: 260)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.5), value: viewModel.progress)

                    // Time display
                    Text(viewModel.formatTime(viewModel.timeLeft))
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .monospacedDigit()
                }

                // Cycle progress
                if viewModel.isWorkoutActive {
                    Text(String.localizedStringWithFormat(
                        NSLocalizedString("workout_cycle_progress", comment: "Cycle X of Y"),
                        viewModel.currentCycle,
                        viewModel.totalCycles
                    ))
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary.opacity(0.7))
                } else {
                    Text(NSLocalizedString("workout_ready", comment: "Ready to start"))
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary.opacity(0.7))
                }
            }

            // Right: Controls (vertical)
            VStack(spacing: 20) {
                if viewModel.isWorkoutActive {
                    // Play/Pause button
                    Button(action: { viewModel.toggleTimer() }) {
                        Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: viewModel.isRunning
                                        ? [Color.red.opacity(0.8), Color.red]
                                        : [viewModel.mode.modeColor, viewModel.mode.modeColorDark]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: viewModel.mode.modeColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isRunning)

                    // Stop button
                    Button(action: { viewModel.stopWorkout() }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.textSecondary)
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                } else {
                    // Workout not active - show start button
                    Button {
                        showCycleSelector = true
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [viewModel.mode.modeColor, viewModel.mode.modeColorDark]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: viewModel.mode.modeColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .frame(width: 180)
        }
        .padding(.horizontal, 40)
        .sheet(isPresented: $showCycleSelector) {
            CycleSelectorView { cycles in
                viewModel.startWorkout(cycles: cycles)
            }
        }
    }
}

struct LandscapeWorkoutModeIndicator: View {
    let mode: WorkoutMode
    let isSelected: Bool

    var body: some View {
        Text(mode.localizedTitle)
            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
            .foregroundColor(isSelected ? .textPrimary : .textSecondary.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .modeSelectionBackground(isSelected: isSelected, color: mode.modeColor, selectedOpacity: (0.2, 0.1))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LandscapeWorkoutTimerView(
            viewModel: WorkoutTimerViewModel(
                settings: .default,
                onCycleComplete: {},
                onWorkoutComplete: {}
            )
        )
    }
}
