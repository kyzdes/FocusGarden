//
//  WorkoutProgressTrackerView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct WorkoutProgressTrackerView: View {
    let progress: WorkoutProgress

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Today's cycles card
                ProgressCard(
                    icon: "figure.run",
                    title: NSLocalizedString("stat_today", comment: "Today"),
                    value: "\(progress.todayCycles)",
                    subtitle: NSLocalizedString("cycles_label", comment: "Cycles"),
                    color: Color.exerciseOrange
                )

                // Streak card
                ProgressCard(
                    icon: "flame.fill",
                    title: NSLocalizedString("stat_streak", comment: "Streak"),
                    value: "\(progress.currentStreak)",
                    subtitle: NSLocalizedString("progress_days", comment: "Days"),
                    color: .orange
                )

                // Total workouts card
                ProgressCard(
                    icon: "trophy.fill",
                    title: NSLocalizedString("workout_total_workouts", comment: "Total Workouts"),
                    value: "\(progress.completedWorkouts)",
                    subtitle: NSLocalizedString("progress_total", comment: "Total"),
                    color: Color.restBlue
                )
            }
        }
        .cardStyle()
        .padding(.horizontal, 4)
    }
}

#Preview {
    WorkoutProgressTrackerView(
        progress: WorkoutProgress(
            totalCycles: 25,
            todayCycles: 3,
            completedWorkouts: 8,
            currentStreak: 5,
            dumbbells: 25,
            kettlebells: 12,
            equipment: ["jumprope", "mat"],
            history: []
        )
    )
    .padding()
}
