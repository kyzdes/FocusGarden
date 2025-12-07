//
//  GymView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct GymView: View {
    let progress: WorkoutProgress

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey("gym_title"))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(LocalizedStringKey("gym_subtitle"))
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)

            // Gym canvas
            ZStack {
                // Gym floor gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.3, green: 0.3, blue: 0.3),
                        Color(red: 0.25, green: 0.25, blue: 0.25),
                        Color(red: 0.2, green: 0.2, blue: 0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Kettlebells layer (background)
                KettlebellsLayer(count: min(progress.kettlebells, 8))

                // Dumbbells layer (foreground)
                DumbbellsLayer(count: min(progress.dumbbells, 12))

                // Equipment layer
                EquipmentLayer(equipment: progress.equipment)

                // Empty state
                if progress.dumbbells == 0 && progress.kettlebells == 0 {
                    VStack(spacing: 8) {
                        Text("💪")
                            .font(.system(size: 48))

                        Text(LocalizedStringKey("gym_empty_title"))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))

                        Text(LocalizedStringKey("gym_empty_subtitle"))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                }
            }
            .frame(height: 400)
            .cornerRadius(16)
            .padding(.horizontal, 20)

            // Gym stats
            HStack(spacing: 0) {
                StatItem(icon: "🏋️", count: progress.dumbbells, label: NSLocalizedString("stat_dumbbells", comment: "Dumbbells stat label"))
                Divider().frame(height: 30)
                StatItem(icon: "🏋️‍♀️", count: progress.kettlebells, label: NSLocalizedString("stat_kettlebells", comment: "Kettlebells stat label"))
                Divider().frame(height: 30)
                StatItem(icon: "🎯", count: progress.equipment.count, label: NSLocalizedString("stat_equipment", comment: "Equipment stat label"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .cardStyle()
    }
}

struct DumbbellsLayer: View {
    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                let row = index / 4
                let col = index % 4
                let scale = 1.0 - Double(row) * 0.15

                DumbbellView()
                    .scaleEffect(scale)
                    .offset(
                        x: CGFloat(col) * (geometry.size.width / 4) + 20,
                        y: CGFloat(row) * 80 + 100
                    )
                    .zIndex(Double(10 - row))
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct DumbbellView: View {
    @State private var bounce = false

    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 12, height: 12)

            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(width: 20, height: 4)

            Circle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 12, height: 12)
        }
        .scaleEffect(bounce ? 1.05 : 1.0)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                bounce = true
            }
        }
    }
}

struct KettlebellsLayer: View {
    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                KettlebellView()
                    .offset(
                        x: CGFloat((index * 90) % Int(geometry.size.width - 40)),
                        y: CGFloat(50 + (index % 3) * 50)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct KettlebellView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Rectangle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 15, height: 3)
                .offset(y: 3)

            // Ball
            Circle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 18, height: 18)
        }
    }
}

struct EquipmentLayer: View {
    let equipment: [String]

    let positions: [(x: CGFloat, y: CGFloat)] = [
        (0.7, 0.3),
        (0.25, 0.25),
        (0.8, 0.6),
        (0.45, 0.5),
        (0.15, 0.7)
    ]

    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(equipment.enumerated()), id: \.offset) { index, item in
                if index < positions.count {
                    EquipmentView(emoji: equipmentEmoji(item))
                        .offset(
                            x: positions[index].x * geometry.size.width,
                            y: positions[index].y * geometry.size.height
                        )
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    private func equipmentEmoji(_ equipment: String) -> String {
        switch equipment {
        case "jumprope": return "🪢"
        case "mat": return "🧘"
        case "barbell": return "🏋️"
        case "bike": return "🚴"
        case "boxing": return "🥊"
        default: return "💪"
        }
    }
}

struct EquipmentView: View {
    let emoji: String
    @State private var scale: CGFloat = 0.8

    var body: some View {
        Text(emoji)
            .font(.system(size: 32))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.spring(response: 0.6, dampingFraction: 0.5)
                ) {
                    scale = 1.0
                }
            }
    }
}

#Preview {
    GymView(progress: WorkoutProgress(
        totalCycles: 25,
        todayCycles: 3,
        completedWorkouts: 8,
        currentStreak: 5,
        dumbbells: 10,
        kettlebells: 5,
        equipment: ["jumprope", "mat", "barbell"],
        history: []
    ))
    .padding()
}
