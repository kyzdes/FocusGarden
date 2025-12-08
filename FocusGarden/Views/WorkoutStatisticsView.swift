//
//  WorkoutStatisticsView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI
import Charts

struct WorkoutStatisticsView: View {
    let progress: WorkoutProgress
    let onClose: () -> Void

    @State private var timeRange: StatisticsView.TimeRange = .week
    private var todayRecord: WorkoutRecord {
        let todayISO = Date().toISODateString()
        return progress.history.first(where: { $0.date == todayISO }) ?? WorkoutRecord(id: UUID(), date: todayISO, cycles: 0, exerciseMinutes: 0)
    }

    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStringKey("statistics_title"))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text(LocalizedStringKey("statistics_subtitle"))
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .frame(width: 44, height: 44)
                            .background(Color.backgroundCard)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 20) {
                        // Today's summary
                        WorkoutTodaySummaryView(record: todayRecord)
                            .padding(.horizontal, 20)

                        // Key Metrics
                        WorkoutMetricsGrid(progress: progress)

                        // Chart Section
                        VStack(spacing: 20) {
                            // Time range selector
                            Picker(NSLocalizedString("time_range_picker", comment: "Time range picker"), selection: $timeRange) {
                                ForEach(StatisticsView.TimeRange.allCases, id: \.self) { range in
                                    Text(range.title).tag(range)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())

                            // Activity Chart
                            WorkoutActivityChart(
                                data: getFilteredData(),
                                timeRange: timeRange
                            )
                        }
                        .padding(20)
                        .cardStyle()
                        .padding(.horizontal, 20)

                        // Achievements
                        WorkoutAchievementsCard(progress: progress)
                            .padding(.horizontal, 20)

                        // Activity Calendar
                        WorkoutActivityCalendar(data: getCalendarData())
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private func getFilteredData() -> [WorkoutRecord] {
        let daysBack: Int
        switch timeRange {
        case .week: daysBack = 7
        case .month: daysBack = 30
        case .all: daysBack = 365
        }

        var data: [WorkoutRecord] = []
        let calendar = Calendar.current

        for i in (0..<daysBack).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            let dateStr = date.toISODateString()

            let record = progress.history.first(where: { $0.date == dateStr })
            data.append(WorkoutRecord(
                id: UUID(),
                date: dateStr,
                cycles: record?.cycles ?? 0,
                exerciseMinutes: record?.exerciseMinutes ?? 0
            ))
        }

        return data
    }

    private func getCalendarData() -> [WorkoutCalendarDay] {
        var data: [WorkoutCalendarDay] = []
        let calendar = Calendar.current

        for i in (0..<90).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            let dateStr = date.toISODateString()

            let record = progress.history.first(where: { $0.date == dateStr })
            data.append(WorkoutCalendarDay(
                date: dateStr,
                count: record?.cycles ?? 0
            ))
        }

        return data
    }
}

struct WorkoutMetricsGrid: View {
    let progress: WorkoutProgress

    var totalExerciseHours: Int {
        let totalMinutes = progress.history.reduce(0) { $0 + $1.exerciseMinutes }
        return totalMinutes / 60
    }

    var totalExerciseMinutes: Int {
        let totalMinutes = progress.history.reduce(0) { $0 + $1.exerciseMinutes }
        return totalMinutes % 60
    }

    var thisWeekTotal: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return progress.history
            .filter { ($0.date.toDate() ?? Date()) >= weekAgo }
            .reduce(0) { $0 + $1.cycles }
    }

    var avgPerDay: Int {
        guard progress.history.count > 0 else { return 0 }
        return progress.totalCycles / progress.history.count
    }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            MetricCard(
                icon: "trophy.fill",
                title: NSLocalizedString("metrics_total_title", comment: "Total cycles title"),
                value: "\(progress.totalCycles)",
                subtitle: NSLocalizedString("cycles_label", comment: "Cycles"),
                color: Color.exerciseOrange
            )

            MetricCard(
                icon: "clock.fill",
                title: NSLocalizedString("metrics_focus_title", comment: "Exercise time title"),
                value: "\(totalExerciseHours)h \(totalExerciseMinutes)m",
                subtitle: NSLocalizedString("metrics_focus_subtitle", comment: "Exercise time subtitle"),
                color: Color.restBlue
            )

            MetricCard(
                icon: "chart.line.uptrend.xyaxis",
                title: NSLocalizedString("metrics_this_week_title", comment: "This week title"),
                value: "\(thisWeekTotal)",
                subtitle: NSLocalizedString("cycles_label", comment: "Cycles"),
                color: .green
            )

            MetricCard(
                icon: "calendar",
                title: NSLocalizedString("metrics_average_title", comment: "Average title"),
                value: "\(avgPerDay)",
                subtitle: NSLocalizedString("metrics_average_subtitle", comment: "Average subtitle"),
                color: .purple
            )
        }
        .padding(.horizontal, 20)
    }
}

struct WorkoutActivityChart: View {
    let data: [WorkoutRecord]
    let timeRange: StatisticsView.TimeRange

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStringKey("statistics_activity"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            if #available(iOS 16.0, *) {
                Chart(data) { record in
                    BarMark(
                        x: .value(NSLocalizedString("chart_date", comment: "Chart date axis"), record.date),
                        y: .value(NSLocalizedString("cycles_label", comment: "Cycles"), record.cycles)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.exerciseOrange, Color.exerciseOrangeDark]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: timeRange == .week ? 1 : 7)) { value in
                        if let dateStr = value.as(String.self),
                           let date = dateStr.toDate() {
                            AxisValueLabel {
                                Text(date.toShortDateString())
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .font(.system(size: 10))
                    }
                }
                .frame(height: 200)
            } else {
                // Fallback for iOS 15
                WorkoutSimpleBarChart(data: data)
                    .frame(height: 200)
            }
        }
    }
}

struct WorkoutSimpleBarChart: View {
    let data: [WorkoutRecord]

    var maxValue: Int {
        data.map { $0.cycles }.max() ?? 1
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(data) { record in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.exerciseOrange, Color.exerciseOrangeDark]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: CGFloat(record.cycles) / CGFloat(maxValue) * 150)

                    Text(record.date.toDate()?.toShortDateString() ?? "")
                        .font(.system(size: 8))
                        .foregroundColor(.textTertiary)
                        .rotationEffect(.degrees(-45))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WorkoutAchievementsCard: View {
    let progress: WorkoutProgress

    var bestDay: WorkoutRecord {
        progress.history.max(by: { $0.cycles < $1.cycles }) ?? WorkoutRecord(id: UUID(), date: "", cycles: 0, exerciseMinutes: 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStringKey("achievements_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            HStack(spacing: 8) {
                AchievementItem(
                    emoji: "🏋️",
                    title: NSLocalizedString("achievements_best_day_title", comment: "Best day title"),
                    value: bestDay.cycles > 0 ? "\(bestDay.cycles)" : "-",
                    subtitle: bestDay.date.toDate()?.toShortDateString() ?? NSLocalizedString("statistics_no_data", comment: "No data label"),
                    color: Color.exerciseOrange
                )

                AchievementItem(
                    emoji: "🔥",
                    title: NSLocalizedString("achievements_current_streak_title", comment: "Current streak title"),
                    value: "\(progress.currentStreak)",
                    subtitle: NSLocalizedString("achievements_current_streak_subtitle", comment: "Current streak subtitle"),
                    color: Color.red
                )

                AchievementItem(
                    emoji: "💪",
                    title: NSLocalizedString("achievements_total_days_title", comment: "Total days title"),
                    value: "\(progress.history.count)",
                    subtitle: NSLocalizedString("achievements_total_days_subtitle", comment: "Total days subtitle"),
                    color: Color.restBlue
                )
            }
        }
        .padding(20)
        .cardStyle()
    }
}

struct WorkoutCalendarDay: Identifiable {
    let id = UUID()
    let date: String
    let count: Int
}

struct WorkoutActivityCalendar: View {
    let data: [WorkoutCalendarDay]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 13)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStringKey("activity_calendar_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(data) { day in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(intensityColor(for: day.count))
                        .frame(height: 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.exerciseOrange.opacity(0.3), lineWidth: 1)
                                .opacity(day.count > 0 ? 1 : 0)
                        )
                }
            }

            // Legend
            HStack(spacing: 8) {
                Text(LocalizedStringKey("activity_calendar_less"))
                    .font(.system(size: 10))
                    .foregroundColor(.textTertiary)

                ForEach([0, 2, 4, 6, 8], id: \.self) { value in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(intensityColor(for: value))
                        .frame(width: 16, height: 16)
                }

                Text(LocalizedStringKey("activity_calendar_more"))
                    .font(.system(size: 10))
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(20)
        .cardStyle()
    }

    private func intensityColor(for count: Int) -> Color {
        switch count {
        case 0:
            return Color.gray.opacity(0.1)
        case 1...2:
            return Color.exerciseOrange.opacity(0.3)
        case 3...4:
            return Color.exerciseOrange.opacity(0.5)
        case 5...6:
            return Color.exerciseOrange.opacity(0.7)
        default:
            return Color.exerciseOrange
        }
    }
}

struct WorkoutTodaySummaryView: View {
    let record: WorkoutRecord

    private var exerciseHours: Int { record.exerciseMinutes / 60 }
    private var exerciseMinutes: Int { record.exerciseMinutes % 60 }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStringKey("today_summary_title"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            HStack(spacing: 12) {
                SummaryItem(
                    icon: "💪",
                    title: NSLocalizedString("cycles_label", comment: "Cycles today"),
                    value: "\(record.cycles)"
                )

                SummaryItem(
                    icon: "🏋️",
                    title: NSLocalizedString("workout_total_workouts", comment: "Workouts today"),
                    value: "\(record.cycles > 0 ? 1 : 0)"
                )

                SummaryItem(
                    icon: "⏱️",
                    title: NSLocalizedString("today_summary_focus", comment: "Exercise time today"),
                    value: String(
                        format: NSLocalizedString("today_summary_focus_value", comment: "Exercise time formatted"),
                        exerciseHours,
                        exerciseMinutes
                    )
                )
            }
        }
        .padding(20)
        .cardStyle()
    }
}

#Preview {
    WorkoutStatisticsView(
        progress: WorkoutProgress(
            totalCycles: 42,
            todayCycles: 5,
            completedWorkouts: 21,
            currentStreak: 7,
            dumbbells: 42,
            kettlebells: 21,
            equipment: ["jumprope", "mat"],
            history: [
                WorkoutRecord(id: UUID(), date: "2024-01-15", cycles: 5, exerciseMinutes: 25),
                WorkoutRecord(id: UUID(), date: "2024-01-16", cycles: 7, exerciseMinutes: 35),
                WorkoutRecord(id: UUID(), date: "2024-01-17", cycles: 4, exerciseMinutes: 20)
            ]
        ),
        onClose: {}
    )
}
