//
//  FocusGardenWidget.swift
//  FocusGardenWidget
//
//  Live Activity implementation for timer
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Activity Attributes

@available(iOS 16.1, *)
struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var remainingSeconds: Int
        public var totalSeconds: Int
        public var modeTitle: String
        public var isWorkoutMode: Bool
        public var currentCycle: Int?
        public var totalCycles: Int?

        public init(remainingSeconds: Int, totalSeconds: Int, modeTitle: String, isWorkoutMode: Bool = false, currentCycle: Int? = nil, totalCycles: Int? = nil) {
            self.remainingSeconds = remainingSeconds
            self.totalSeconds = totalSeconds
            self.modeTitle = modeTitle
            self.isWorkoutMode = isWorkoutMode
            self.currentCycle = currentCycle
            self.totalCycles = totalCycles
        }
    }

    public var title: String

    public init(title: String) {
        self.title = title
    }
}

// MARK: - Live Activity Widget

@available(iOS 16.1, *)
struct FocusGardenWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen view
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded view
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Image(systemName: context.state.isWorkoutMode ? "figure.run" : "timer")
                            .foregroundColor(context.state.isWorkoutMode ? .orange : .green)
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.state.modeTitle)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if context.state.isWorkoutMode,
                               let current = context.state.currentCycle,
                               let total = context.state.totalCycles {
                                Text("Cycle \(current)/\(total)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatTime(context.state.remainingSeconds))
                        .font(.title2.bold().monospacedDigit())
                        .foregroundColor(.primary)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        ProgressView(value: Double(context.state.totalSeconds - context.state.remainingSeconds),
                                   total: Double(context.state.totalSeconds))
                            .tint(context.state.isWorkoutMode ? .orange : .green)

                        Text("\(Int((Double(context.state.totalSeconds - context.state.remainingSeconds) / Double(context.state.totalSeconds)) * 100))%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            } compactLeading: {
                // Compact leading (left pill)
                Image(systemName: context.state.isWorkoutMode ? "figure.run" : "timer")
                    .foregroundColor(context.state.isWorkoutMode ? .orange : .green)
            } compactTrailing: {
                // Compact trailing (right text)
                Text(formatTime(context.state.remainingSeconds))
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(.primary)
            } minimal: {
                // Minimal view (single icon when multiple activities)
                Image(systemName: context.state.isWorkoutMode ? "figure.run" : "timer")
                    .foregroundColor(context.state.isWorkoutMode ? .orange : .green)
            }
            .keylineTint(context.state.isWorkoutMode ? .orange : .green)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

// MARK: - Lock Screen View

@available(iOS 16.1, *)
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<TimerActivityAttributes>

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: context.state.isWorkoutMode ? "figure.run" : "timer")
                    .foregroundColor(context.state.isWorkoutMode ? .orange : .green)

                Text(context.attributes.title)
                    .font(.headline)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(context.state.modeTitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if context.state.isWorkoutMode,
                       let current = context.state.currentCycle,
                       let total = context.state.totalCycles {
                        Text("Cycle \(current)/\(total)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Time and Progress
            HStack {
                Text(formatTime(context.state.remainingSeconds))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .monospacedDigit()

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int((Double(context.state.totalSeconds - context.state.remainingSeconds) / Double(context.state.totalSeconds)) * 100))%")
                        .font(.caption.bold())

                    ProgressView(value: Double(context.state.totalSeconds - context.state.remainingSeconds),
                               total: Double(context.state.totalSeconds))
                        .tint(context.state.isWorkoutMode ? .orange : .green)
                        .frame(width: 80)
                }
            }
        }
        .padding()
        .activityBackgroundTint(Color.black.opacity(0.2))
        .activitySystemActionForegroundColor(.white)
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

// MARK: - Widget Bundle

@main
@available(iOS 16.1, *)
struct FocusGardenWidgetBundle: WidgetBundle {
    var body: some Widget {
        FocusGardenWidget()
    }
}
