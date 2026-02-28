//
//  Extensions.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI
import UIKit

// MARK: - Date Formatters (cached)

private enum DateFormatters {
    static let medium: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    static let iso: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static let short: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f
    }()
}

// MARK: - Date Extensions

extension Date {
    func toDateString() -> String {
        DateFormatters.medium.string(from: self)
    }

    func toISODateString() -> String {
        DateFormatters.iso.string(from: self)
    }

    func toShortDateString() -> String {
        DateFormatters.short.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        DateFormatters.iso.date(from: self)
    }
}

// MARK: - Color Extensions

extension Color {
    private static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        })
    }

    static let focusGreen = dynamicColor(
        light: UIColor(red: 0.62, green: 0.85, blue: 0.77, alpha: 1),
        dark: UIColor(red: 0.55, green: 0.86, blue: 0.76, alpha: 1)
    )

    static let focusGreenDark = dynamicColor(
        light: UIColor(red: 0.48, green: 0.77, blue: 0.68, alpha: 1),
        dark: UIColor(red: 0.43, green: 0.71, blue: 0.63, alpha: 1)
    )

    static let breakBlue = dynamicColor(
        light: UIColor(red: 0.66, green: 0.77, blue: 0.88, alpha: 1),
        dark: UIColor(red: 0.54, green: 0.68, blue: 0.82, alpha: 1)
    )

    static let breakBlueDark = dynamicColor(
        light: UIColor(red: 0.55, green: 0.68, blue: 0.83, alpha: 1),
        dark: UIColor(red: 0.47, green: 0.61, blue: 0.77, alpha: 1)
    )

    static let longBreakPurple = dynamicColor(
        light: UIColor(red: 0.83, green: 0.65, blue: 0.78, alpha: 1),
        dark: UIColor(red: 0.76, green: 0.59, blue: 0.77, alpha: 1)
    )

    static let longBreakPurpleDark = dynamicColor(
        light: UIColor(red: 0.76, green: 0.56, blue: 0.71, alpha: 1),
        dark: UIColor(red: 0.67, green: 0.49, blue: 0.66, alpha: 1)
    )

    static let textPrimary = dynamicColor(
        light: UIColor(red: 0.18, green: 0.22, blue: 0.28, alpha: 1),
        dark: UIColor(red: 0.92, green: 0.94, blue: 0.97, alpha: 1)
    )

    static let textSecondary = dynamicColor(
        light: UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1),
        dark: UIColor(red: 0.76, green: 0.79, blue: 0.84, alpha: 1)
    )

    static let textTertiary = dynamicColor(
        light: UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1),
        dark: UIColor(red: 0.62, green: 0.66, blue: 0.70, alpha: 1)
    )

    static let backgroundLight = dynamicColor(
        light: UIColor(red: 0.96, green: 0.95, blue: 0.94, alpha: 1),
        dark: UIColor(red: 0.08, green: 0.09, blue: 0.11, alpha: 1)
    )

    static let backgroundCard = dynamicColor(
        light: UIColor.white,
        dark: UIColor(red: 0.13, green: 0.14, blue: 0.16, alpha: 1)
    )

    static let skyBlue = dynamicColor(
        light: UIColor(red: 0.89, green: 0.95, blue: 0.97, alpha: 1),
        dark: UIColor(red: 0.13, green: 0.16, blue: 0.18, alpha: 1)
    )

    static let skyBlueDark = dynamicColor(
        light: UIColor(red: 0.82, green: 0.91, blue: 0.94, alpha: 1),
        dark: UIColor(red: 0.08, green: 0.11, blue: 0.12, alpha: 1)
    )

    static let grassGreen = dynamicColor(
        light: UIColor(red: 0.94, green: 0.97, blue: 0.91, alpha: 1),
        dark: UIColor(red: 0.12, green: 0.14, blue: 0.12, alpha: 1)
    )

    static let grassGreenDark = dynamicColor(
        light: UIColor(red: 0.78, green: 0.90, blue: 0.79, alpha: 1),
        dark: UIColor(red: 0.16, green: 0.19, blue: 0.18, alpha: 1)
    )

    // Workout Colors
    static let exerciseOrange = dynamicColor(
        light: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.65, blue: 0.3, alpha: 1)
    )

    static let exerciseOrangeDark = dynamicColor(
        light: UIColor(red: 0.95, green: 0.5, blue: 0.1, alpha: 1),
        dark: UIColor(red: 0.9, green: 0.55, blue: 0.2, alpha: 1)
    )

    static let restBlue = dynamicColor(
        light: UIColor(red: 0.4, green: 0.7, blue: 0.95, alpha: 1),
        dark: UIColor(red: 0.45, green: 0.75, blue: 1.0, alpha: 1)
    )

    static let restBlueDark = dynamicColor(
        light: UIColor(red: 0.3, green: 0.6, blue: 0.85, alpha: 1),
        dark: UIColor(red: 0.35, green: 0.65, blue: 0.9, alpha: 1)
    )

    // OLED-specific colors
    static let oledBlack = Color(red: 0, green: 0, blue: 0)

    static let textPrimaryDim = dynamicColor(
        light: UIColor(red: 0.18, green: 0.22, blue: 0.28, alpha: 0.85),
        dark: UIColor(red: 0.92, green: 0.94, blue: 0.97, alpha: 0.85)
    )

    static let textSecondaryDim = dynamicColor(
        light: UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 0.6),
        dark: UIColor(red: 0.76, green: 0.79, blue: 0.84, alpha: 0.6)
    )
}

// MARK: - TimerMode Colors

extension TimerMode {
    var modeColor: Color {
        switch self {
        case .focus: return .focusGreen
        case .shortBreak: return .breakBlue
        case .longBreak: return .longBreakPurple
        }
    }

    var modeColorDark: Color {
        switch self {
        case .focus: return .focusGreenDark
        case .shortBreak: return .breakBlueDark
        case .longBreak: return .longBreakPurpleDark
        }
    }
}

// MARK: - WorkoutMode Colors

extension WorkoutMode {
    var modeColor: Color {
        switch self {
        case .exercise: return .exerciseOrange
        case .rest: return .restBlue
        }
    }

    var modeColorDark: Color {
        switch self {
        case .exercise: return .exerciseOrangeDark
        case .rest: return .restBlueDark
        }
    }
}

// MARK: - Time Formatting

extension Int {
    var formattedTime: String {
        let minutes = self / 60
        let secs = self % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

// MARK: - View Extensions

private struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.backgroundCard)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.06), radius: 12, x: 4, y: 4)
            .shadow(color: Color.white.opacity(colorScheme == .dark ? 0.05 : 0.9), radius: 12, x: -4, y: -4)
    }
}

private struct ModeSelectionBackground: ViewModifier {
    let isSelected: Bool
    let color: Color
    let selectedOpacity: (start: Double, end: Double)

    init(isSelected: Bool, color: Color, selectedOpacity: (Double, Double) = (0.15, 0.05)) {
        self.isSelected = isSelected
        self.color = color
        self.selectedOpacity = selectedOpacity
    }

    func body(content: Content) -> some View {
        content
            .background(
                isSelected
                    ? LinearGradient(
                        gradient: Gradient(colors: [color.opacity(selectedOpacity.start), color.opacity(selectedOpacity.end)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
            )
            .cornerRadius(12)
    }
}

extension View {
    func modeSelectionBackground(isSelected: Bool, color: Color, selectedOpacity: (Double, Double) = (0.15, 0.05)) -> some View {
        modifier(ModeSelectionBackground(isSelected: isSelected, color: color, selectedOpacity: selectedOpacity))
    }

    func cardStyle() -> some View {
        modifier(CardStyle())
    }

    func buttonStyle(color: Color) -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}
