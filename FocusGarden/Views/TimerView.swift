//
//  TimerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Mode selector
            HStack(spacing: 8) {
                ForEach(TimerMode.allCases, id: \.self) { mode in
                    ModeButton(
                        mode: mode,
                        isSelected: viewModel.mode == mode,
                        isDisabled: viewModel.isRunning
                    ) {
                        viewModel.switchMode(mode)
                    }
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
                        viewModel.mode.modeColor,
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

                    Text(String.localizedStringWithFormat(
                        NSLocalizedString("cycle_number", comment: "Current cycle number"),
                        viewModel.completedCycles + 1
                    ))
                        .font(.system(size: 14))
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(.vertical, 40)

            // Control buttons
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
                                    : [viewModel.mode.modeColor, viewModel.mode.modeColorDark]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: viewModel.mode.modeColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isRunning)

                // Reset button
                Button(action: { viewModel.resetTimer() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 24))
                        .foregroundColor(.textSecondary)
                        .frame(width: 64, height: 64)
                        .background(Color.backgroundCard)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.1), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.bottom, 32)
        }
        .cardStyle()
    }
}

struct ModeButton: View {
    let mode: TimerMode
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(mode.localizedTitle)
                .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .modeSelectionBackground(isSelected: isSelected, color: mode.modeColor)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview {
    TimerView(
        viewModel: TimerViewModel(
            settings: .default,
            onFocusComplete: {},
            onBreakComplete: {}
        )
    )
    .padding()
}
