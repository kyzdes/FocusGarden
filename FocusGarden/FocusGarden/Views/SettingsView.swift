//
//  SettingsView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: TimerSettings
    let onClose: () -> Void

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Timer Duration Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.focusGreen)
                                Text("Timer Duration")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            // Focus Time
                            TimerSlider(
                                title: "Focus Time",
                                value: $settings.focusTime,
                                range: 5...60,
                                step: 5,
                                color: .focusGreen,
                                unit: "min"
                            )

                            // Short Break
                            TimerSlider(
                                title: "Short Break",
                                value: $settings.breakTime,
                                range: 1...15,
                                step: 1,
                                color: .breakBlue,
                                unit: "min"
                            )

                            // Long Break
                            TimerSlider(
                                title: "Long Break",
                                value: $settings.longBreakTime,
                                range: 5...30,
                                step: 5,
                                color: .longBreakPurple,
                                unit: "min"
                            )
                        }
                        .padding(20)
                        .cardStyle()

                        // Sound Settings Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: settings.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .foregroundColor(.focusGreen)
                                Text("Sound")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Toggle(isOn: $settings.soundEnabled) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Completion Sound")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)

                                    Text("Play sound when timer completes")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .focusGreen))
                        }
                        .padding(20)
                        .cardStyle()

                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("💡")
                                    .font(.system(size: 20))
                                Text("The Pomodoro Technique")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Text("Work for focused intervals (usually 25 minutes), then take a short break. After 4 cycles, take a longer break. This helps maintain high focus and prevents burnout.")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.grassGreen.opacity(0.5),
                                    Color.skyBlue.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                        onClose()
                    }
                    .foregroundColor(.focusGreen)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct TimerSlider: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let color: Color
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)

                Spacer()

                Text("\(value) \(unit)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }

            Slider(
                value: Binding(
                    get: { Double(value) },
                    set: { value = Int($0) }
                ),
                in: Double(range.lowerBound)...Double(range.upperBound),
                step: Double(step)
            )
            .accentColor(color)
        }
    }
}

#Preview {
    SettingsView(
        settings: .constant(.default),
        onClose: {}
    )
}
