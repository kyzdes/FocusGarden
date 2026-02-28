//
//  LandscapePomodoroTimerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct LandscapePomodoroTimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 40) {
            // Left: Mode selector (vertical)
            VStack(spacing: 16) {
                ForEach(TimerMode.allCases, id: \.self) { mode in
                    LandscapeModeButton(
                        mode: mode,
                        isSelected: viewModel.mode == mode,
                        isDisabled: viewModel.isRunning
                    ) {
                        viewModel.switchMode(mode)
                    }
                }
            }
            .frame(width: 180)

            // Center: Timer circle + cycle count
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

                // Cycle count
                Text(String.localizedStringWithFormat(
                    NSLocalizedString("cycle_number", comment: "Current cycle number"),
                    viewModel.completedCycles + 1
                ))
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary.opacity(0.7))
            }

            // Right: Controls (vertical)
            VStack(spacing: 20) {
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

                // Reset button
                Button(action: { viewModel.resetTimer() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 28))
                        .foregroundColor(.textSecondary)
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .frame(width: 180)
        }
        .padding(.horizontal, 40)
    }
}

struct LandscapeModeButton: View {
    let mode: TimerMode
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(mode.localizedTitle)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .textPrimary : .textSecondary.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .modeSelectionBackground(isSelected: isSelected, color: mode.modeColor, selectedOpacity: (0.2, 0.1))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LandscapePomodoroTimerView(
            viewModel: TimerViewModel(
                settings: .default,
                onFocusComplete: {},
                onBreakComplete: {}
            )
        )
    }
}
