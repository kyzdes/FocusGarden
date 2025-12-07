//
//  WorkoutTimerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct WorkoutTimerView: View {
    @ObservedObject var viewModel: WorkoutTimerViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showCycleSelector = false

    var body: some View {
        VStack(spacing: 0) {
            // Mode indicator (not selectable - just shows current mode)
            HStack(spacing: 8) {
                ForEach(WorkoutMode.allCases, id: \.self) { mode in
                    WorkoutModeIndicator(
                        mode: mode,
                        isSelected: viewModel.mode == mode
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            // Circular timer
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(colorScheme == .dark ? 0.35 : 0.1), lineWidth: 12)
                    .frame(width: 280, height: 280)

                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        modeColor,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 280, height: 280)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: viewModel.progress)

                // Time display
                VStack(spacing: 8) {
                    Text(viewModel.formatTime(viewModel.timeLeft))
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .monospacedDigit()

                    if viewModel.isWorkoutActive {
                        Text(String.localizedStringWithFormat(
                            NSLocalizedString("workout_cycle_progress", comment: "Cycle X of Y"),
                            viewModel.currentCycle,
                            viewModel.totalCycles
                        ))
                            .font(.system(size: 14))
                            .foregroundColor(.textTertiary)
                    } else {
                        Text(NSLocalizedString("workout_ready", comment: "Ready to start"))
                            .font(.system(size: 14))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(.vertical, 40)

            // Control buttons
            if viewModel.isWorkoutActive {
                // Workout active - show play/pause and stop
                HStack(spacing: 16) {
                    // Play/Pause button
                    Button(action: { viewModel.toggleTimer() }) {
                        Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: viewModel.isRunning
                                        ? [Color.red.opacity(0.8), Color.red]
                                        : [modeColor, modeColorDark]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: modeColor.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(viewModel.isRunning ? 1.0 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isRunning)

                    // Stop button
                    Button(action: { viewModel.stopWorkout() }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textSecondary)
                            .frame(width: 64, height: 64)
                            .background(Color.backgroundCard)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.1), radius: 8, x: 0, y: 4)
                    }
                }
            } else {
                // Workout not active - show start button
                Button {
                    showCycleSelector = true
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(NSLocalizedString("workout_start", comment: "Start Workout"))
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 64)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [modeColor, modeColorDark]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: modeColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }
            }

            Spacer()
                .frame(height: 32)
        }
        .cardStyle()
        .sheet(isPresented: $showCycleSelector) {
            CycleSelectorView { cycles in
                viewModel.startWorkout(cycles: cycles)
            }
        }
    }

    private var modeColor: Color {
        switch viewModel.mode {
        case .exercise:
            return Color.exerciseOrange
        case .rest:
            return Color.restBlue
        }
    }

    private var modeColorDark: Color {
        switch viewModel.mode {
        case .exercise:
            return Color.exerciseOrangeDark
        case .rest:
            return Color.restBlueDark
        }
    }
}

struct WorkoutModeIndicator: View {
    let mode: WorkoutMode
    let isSelected: Bool

    var body: some View {
        Text(mode.localizedTitle)
            .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
            .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                    ? LinearGradient(
                        gradient: Gradient(colors: [modeColor.opacity(0.15), modeColor.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
            )
            .cornerRadius(12)
    }

    private var modeColor: Color {
        switch mode {
        case .exercise:
            return Color.exerciseOrange
        case .rest:
            return Color.restBlue
        }
    }
}

#Preview {
    WorkoutTimerView(
        viewModel: WorkoutTimerViewModel(
            settings: .default,
            onCycleComplete: {},
            onWorkoutComplete: {}
        )
    )
    .padding()
}
