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
        HStack(spacing: 24) {
            // Left: Mode selector (vertical)
            VStack(spacing: 12) {
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
            .frame(width: 140)

            // Center: Timer circle + cycle count
            VStack(spacing: 16) {
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.gray.opacity(colorScheme == .dark ? 0.25 : 0.1), lineWidth: 10)
                        .frame(width: 200, height: 200)

                    // Progress circle
                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(
                            modeColor,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.5), value: viewModel.progress)

                    // Time display
                    Text(viewModel.formatTime(viewModel.timeLeft))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .monospacedDigit()
                }

                // Cycle count
                Text(String.localizedStringWithFormat(
                    NSLocalizedString("cycle_number", comment: "Current cycle number"),
                    viewModel.completedCycles + 1
                ))
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary.opacity(0.7))
            }

            // Right: Controls (vertical)
            VStack(spacing: 16) {
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
                        .shadow(color: modeColor.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isRunning)

                // Reset button
                Button(action: { viewModel.resetTimer() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 24))
                        .foregroundColor(.textSecondary)
                        .frame(width: 64, height: 64)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .frame(width: 140)
        }
        .padding(.horizontal, 40)
    }

    private var modeColor: Color {
        switch viewModel.mode {
        case .focus:
            return .focusGreen
        case .shortBreak:
            return .breakBlue
        case .longBreak:
            return .longBreakPurple
        }
    }

    private var modeColorDark: Color {
        switch viewModel.mode {
        case .focus:
            return .focusGreenDark
        case .shortBreak:
            return .breakBlueDark
        case .longBreak:
            return .longBreakPurpleDark
        }
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
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .textPrimary : .textSecondary.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected
                        ? LinearGradient(
                            gradient: Gradient(colors: [modeColor.opacity(0.2), modeColor.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                )
                .cornerRadius(10)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    private var modeColor: Color {
        switch mode {
        case .focus:
            return .focusGreen
        case .shortBreak:
            return .breakBlue
        case .longBreak:
            return .longBreakPurple
        }
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
