//
//  ProgressTrackerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct ProgressTrackerView: View {
    let progress: Progress

    var body: some View {
        VStack(spacing: 16) {
            // Today's progress
            HStack(spacing: 16) {
                ProgressCard(
                    icon: "flame.fill",
                    title: "Today",
                    value: "\(progress.todayPomodoros)",
                    subtitle: "Pomodoros",
                    color: .orange
                )

                ProgressCard(
                    icon: "calendar",
                    title: "Streak",
                    value: "\(progress.currentStreak)",
                    subtitle: "Days",
                    color: .green
                )

                ProgressCard(
                    icon: "target",
                    title: "Total",
                    value: "\(progress.totalPomodoros)",
                    subtitle: "Sessions",
                    color: .blue
                )
            }
        }
        .cardStyle()
        .padding(.horizontal, 4)
    }
}

struct ProgressCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.15))
                )

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)

            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProgressTrackerView(progress: Progress(
        totalPomodoros: 42,
        todayPomodoros: 5,
        currentStreak: 7,
        trees: 20,
        clouds: 10,
        animals: ["butterfly", "bird"],
        history: []
    ))
    .padding()
}
