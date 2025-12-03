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
                    title: NSLocalizedString("progress_today", comment: "Today's progress title"),
                    value: "\(progress.todayPomodoros)",
                    subtitle: NSLocalizedString("progress_pomodoros", comment: "Pomodoros subtitle"),
                    color: .orange
                )

                ProgressCard(
                    icon: "calendar",
                    title: NSLocalizedString("progress_streak", comment: "Streak title"),
                    value: "\(progress.currentStreak)",
                    subtitle: NSLocalizedString("progress_days", comment: "Days subtitle"),
                    color: .green
                )

                ProgressCard(
                    icon: "target",
                    title: NSLocalizedString("progress_total", comment: "Total title"),
                    value: "\(progress.completedSessions)",
                    subtitle: NSLocalizedString("progress_sessions", comment: "Sessions subtitle"),
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
        completedSessions: 21,
        currentStreak: 7,
        trees: 20,
        clouds: 10,
        animals: ["butterfly", "bird"],
        history: []
    ))
    .padding()
}
