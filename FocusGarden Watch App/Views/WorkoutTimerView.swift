//
//  WorkoutTimerView.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import SwiftUI

struct WorkoutTimerView: View {
    @EnvironmentObject var viewModel: WatchViewModel
    @State private var showCycleSelector = false
    @State private var selectedCycles: Int = 3

    var body: some View {
        VStack(spacing: 8) {
            // Mode indicator
            Text(viewModel.currentWorkoutMode.localizedTitle)
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

                    if viewModel.isWorkoutActive {
                        Text("\\(viewModel.currentCycle)/\\(viewModel.totalCycles)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Ready")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Control buttons
            if viewModel.isWorkoutActive {
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
                        viewModel.stopWorkout()
                        WKInterfaceDevice.current().play(.click)
                    }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Button(action: {
                    showCycleSelector = true
                }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(modeColor)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .sheet(isPresented: $showCycleSelector) {
            CycleSelectorView(selectedCycles: $selectedCycles) {
                viewModel.startWorkout(cycles: selectedCycles)
                WKInterfaceDevice.current().play(.start)
            }
        }
    }

    private var modeColor: Color {
        switch viewModel.currentWorkoutMode {
        case .exercise:
            return Color.orange
        case .rest:
            return Color.blue
        }
    }
}

struct CycleSelectorView: View {
    @Binding var selectedCycles: Int
    var onStart: () -> Void
    @Environment(\\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            Text("Select Cycles")
                .font(.headline)

            Picker("Cycles", selection: $selectedCycles) {
                ForEach(1...10, id: \\.self) { cycles in
                    Text("\\(cycles)").tag(cycles)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)

            Button("Start") {
                onStart()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    WorkoutTimerView()
        .environmentObject(WatchViewModel())
}
