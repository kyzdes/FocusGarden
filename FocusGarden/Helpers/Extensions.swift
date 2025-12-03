//
//  Extensions.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

// MARK: - Date Extensions

extension Date {
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

    func toISODateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func toShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}

// MARK: - Color Extensions

extension Color {
    static let focusGreen = Color(red: 0.62, green: 0.85, blue: 0.77)
    static let focusGreenDark = Color(red: 0.48, green: 0.77, blue: 0.68)
    static let breakBlue = Color(red: 0.66, green: 0.77, blue: 0.88)
    static let breakBlueDark = Color(red: 0.55, green: 0.68, blue: 0.83)
    static let longBreakPurple = Color(red: 0.83, green: 0.65, blue: 0.78)
    static let longBreakPurpleDark = Color(red: 0.76, green: 0.56, blue: 0.71)

    static let textPrimary = Color(red: 0.18, green: 0.22, blue: 0.28)
    static let textSecondary = Color(red: 0.42, green: 0.45, blue: 0.50)
    static let textTertiary = Color(red: 0.61, green: 0.64, blue: 0.69)

    static let backgroundLight = Color(red: 0.96, green: 0.95, blue: 0.94)
    static let backgroundCard = Color.white

    static let skyBlue = Color(red: 0.89, green: 0.95, blue: 0.97)
    static let skyBlueDark = Color(red: 0.82, green: 0.91, blue: 0.94)
    static let grassGreen = Color(red: 0.94, green: 0.97, blue: 0.91)
    static let grassGreenDark = Color(red: 0.78, green: 0.90, blue: 0.79)
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.backgroundCard)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 4, y: 4)
            .shadow(color: Color.white.opacity(0.9), radius: 12, x: -4, y: -4)
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
