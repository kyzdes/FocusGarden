//
//  StatisticsView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI
import Charts

struct StatisticsView: View {
    let progress: Progress
    let onClose: () -> Void

    @State private var timeRange: TimeRange = .week

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All"
    }

    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Statistics")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text("Your productivity insights")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                ScrollView {
                    VStack(spacing: 16) {
                        // Key Metrics
                        MetricsGrid(progress: progress)

                        // Chart Section
                        VStack(spacing: 16) {
                            // Time range selector
                            Picker("Time Range", selection: $timeRange) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 20)

                            // Activity Chart
                            ActivityChart(
                                data: getFilteredData(),
                                timeRange: timeRange
                            )
                        }
                        .cardStyle()
                        .padding(.horizontal, 20)

                        // Achievements
                        AchievementsCard(progress: progress)
                            .padding(.horizontal, 20)

                        // Activity Calendar
                        ActivityCalendar(data: getCalendarData())
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }

    private func getFilteredData() -> [DailyRecord] {
        let daysBack: Int
        switch timeRange {
        case .week: daysBack = 7
        case .month: daysBack = 30
        case .all: daysBack = 365
        }

        var data: [DailyRecord] = []
        let calendar = Calendar.current

        for i in (0..<daysBack).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            let dateStr = date.toISODateString()

            let record = progress.history.first(where: { $0.date == dateStr })
            data.append(DailyRecord(
                date: dateStr,
                pomodoros: record?.pomodoros ?? 0,
                focusMinutes: record?.focusMinutes ?? 0
            ))
        }

        return data
    }

    private func getCalendarData() -> [CalendarDay] {
        var data: [CalendarDay] = []
        let calendar = Calendar.current

        for i in (0..<90).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            let dateStr = date.toISODateString()

            let record = progress.history.first(where: { $0.date == dateStr })
            data.append(CalendarDay(
                date: dateStr,
                count: record?.pomodoros ?? 0
            ))
        }

        return data
    }
}

struct MetricsGrid: View {
    let progress: Progress

    var totalFocusHours: Int {
        let totalMinutes = progress.history.reduce(0) { $0 + $1.focusMinutes }
        return totalMinutes / 60
    }

    var totalFocusMinutes: Int {
        let totalMinutes = progress.history.reduce(0) { $0 + $1.focusMinutes }
        return totalMinutes % 60
    }

    var thisWeekTotal: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return progress.history
            .filter { ($0.date.toDate() ?? Date()) >= weekAgo }
            .reduce(0) { $0 + $1.pomodoros }
    }

    var avgPerDay: Int {
        guard progress.history.count > 0 else { return 0 }
        return progress.totalPomodoros / progress.history.count
    }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            MetricCard(
                icon: "trophy.fill",
                title: "Total",
                value: "\(progress.totalPomodoros)",
                subtitle: "pomodoros",
                color: .orange
            )

            MetricCard(
                icon: "clock.fill",
                title: "Focus Time",
                value: "\(totalFocusHours)h \(totalFocusMinutes)m",
                subtitle: "total time",
                color: .blue
            )

            MetricCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "This Week",
                value: "\(thisWeekTotal)",
                subtitle: "sessions",
                color: .green
            )

            MetricCard(
                icon: "calendar",
                title: "Average",
                value: "\(avgPerDay)",
                subtitle: "per day",
                color: .purple
            )
        }
        .padding(.horizontal, 20)
    }
}

struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )

                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(.textTertiary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)

                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .cardStyle()
    }
}

struct ActivityChart: View {
    let data: [DailyRecord]
    let timeRange: StatisticsView.TimeRange

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 20)

            if #available(iOS 16.0, *) {
                Chart(data) { record in
                    BarMark(
                        x: .value("Date", record.date),
                        y: .value("Pomodoros", record.pomodoros)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.focusGreen, Color.focusGreenDark]),
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
                .padding(.horizontal, 20)
            } else {
                // Fallback for iOS 15
                SimpleBarChart(data: data)
                    .frame(height: 200)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
    }
}

struct SimpleBarChart: View {
    let data: [DailyRecord]

    var maxValue: Int {
        data.map { $0.pomodoros }.max() ?? 1
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(data) { record in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.focusGreen, Color.focusGreenDark]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: CGFloat(record.pomodoros) / CGFloat(maxValue) * 150)

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

struct AchievementsCard: View {
    let progress: Progress

    var bestDay: DailyRecord {
        progress.history.max(by: { $0.pomodoros < $1.pomodoros }) ?? DailyRecord(date: "", pomodoros: 0, focusMinutes: 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            HStack(spacing: 12) {
                AchievementItem(
                    emoji: "🏆",
                    title: "Best Day",
                    value: bestDay.pomodoros > 0 ? "\(bestDay.pomodoros)" : "-",
                    subtitle: bestDay.date.toDate()?.toShortDateString() ?? "No data",
                    color: Color.orange
                )

                AchievementItem(
                    emoji: "🔥",
                    title: "Current Streak",
                    value: "\(progress.currentStreak)",
                    subtitle: "days in a row",
                    color: Color.red
                )

                AchievementItem(
                    emoji: "🎯",
                    title: "Total Days",
                    value: "\(progress.history.count)",
                    subtitle: "with activity",
                    color: Color.purple
                )
            }
        }
        .padding(20)
        .cardStyle()
    }
}

struct AchievementItem: View {
    let emoji: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 32))

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)

            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.textSecondary)

                Text(subtitle)
                    .font(.system(size: 9))
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: String
    let count: Int
}

struct ActivityCalendar: View {
    let data: [CalendarDay]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 13)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Calendar (Last 90 Days)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(data) { day in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(intensityColor(for: day.count))
                        .frame(height: 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.focusGreen.opacity(0.3), lineWidth: 1)
                                .opacity(day.count > 0 ? 1 : 0)
                        )
                }
            }

            // Legend
            HStack(spacing: 4) {
                Text("Less")
                    .font(.system(size: 10))
                    .foregroundColor(.textTertiary)

                ForEach([0, 2, 4, 6, 8], id: \.self) { value in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(intensityColor(for: value))
                        .frame(width: 16, height: 16)
                }

                Text("More")
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
            return Color.focusGreen.opacity(0.3)
        case 3...4:
            return Color.focusGreen.opacity(0.5)
        case 5...6:
            return Color.focusGreen.opacity(0.7)
        default:
            return Color.focusGreen
        }
    }
}

#Preview {
    StatisticsView(
        progress: Progress(
            totalPomodoros: 42,
            todayPomodoros: 5,
            currentStreak: 7,
            trees: 20,
            clouds: 10,
            animals: ["butterfly", "bird"],
            history: [
                DailyRecord(date: "2024-01-15", pomodoros: 5, focusMinutes: 125),
                DailyRecord(date: "2024-01-16", pomodoros: 7, focusMinutes: 175),
                DailyRecord(date: "2024-01-17", pomodoros: 4, focusMinutes: 100)
            ]
        ),
        onClose: {}
    )
}
