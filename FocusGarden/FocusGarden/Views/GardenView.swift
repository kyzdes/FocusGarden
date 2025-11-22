//
//  GardenView.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

struct GardenView: View {
    let progress: Progress

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Focus Garden")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text("Complete Pomodoros to grow your sanctuary")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)

            // Garden canvas
            ZStack {
                // Sky gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.skyBlue, Color.skyBlueDark]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Clouds layer
                CloudsLayer(count: min(progress.clouds, 8))

                // Ground
                VStack {
                    Spacer()

                    ZStack {
                        // Grass gradient
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.grassGreenDark.opacity(0.3),
                                Color.grassGreen,
                                Color.grassGreenDark
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Trees
                        TreesLayer(count: min(progress.trees, 12))

                        // Animals
                        AnimalsLayer(animals: progress.animals)
                    }
                    .frame(height: 250)
                }

                // Empty state
                if progress.trees == 0 && progress.clouds == 0 {
                    VStack(spacing: 8) {
                        Text("🌱")
                            .font(.system(size: 48))

                        Text("Your garden awaits")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)

                        Text("Complete your first Pomodoro to plant a tree")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                }
            }
            .frame(height: 400)
            .cornerRadius(16)
            .padding(.horizontal, 20)

            // Garden stats
            HStack(spacing: 0) {
                StatItem(icon: "🌳", count: progress.trees, label: "Trees")
                Divider().frame(height: 30)
                StatItem(icon: "☁️", count: progress.clouds, label: "Clouds")
                Divider().frame(height: 30)
                StatItem(icon: "🦋", count: progress.animals.count, label: "Animals")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .cardStyle()
    }
}

struct StatItem: View {
    let icon: String
    let count: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text(icon)
                    .font(.system(size: 16))
                Text("\(count)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
            }

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CloudsLayer: View {
    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                CloudShape()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 60, height: 30)
                    .offset(
                        x: CGFloat((index * 80) % Int(geometry.size.width - 60)),
                        y: CGFloat(20 + (index % 3) * 40)
                    )
                    .animation(
                        Animation.easeInOut(duration: 3 + Double(index % 3))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: count
                    )
            }
        }
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Simple cloud shape using circles
        let centerY = rect.midY

        path.addEllipse(in: CGRect(x: rect.minX + 10, y: centerY - 10, width: 20, height: 20))
        path.addEllipse(in: CGRect(x: rect.minX + 20, y: centerY - 15, width: 25, height: 25))
        path.addEllipse(in: CGRect(x: rect.minX + 35, y: centerY - 10, width: 20, height: 20))

        return path
    }
}

struct TreesLayer: View {
    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                let row = index / 4
                let col = index % 4
                let scale = 1.0 - Double(row) * 0.15

                TreeView()
                    .scaleEffect(scale)
                    .offset(
                        x: CGFloat(col) * (geometry.size.width / 4) + 20,
                        y: CGFloat(row) * 60 + 50
                    )
                    .zIndex(Double(10 - row))
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct TreeView: View {
    @State private var animate = false

    var body: some View {
        VStack(spacing: 0) {
            // Leaves
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.8))
                    .frame(width: 30, height: 30)
                    .offset(x: -5, y: 5)

                Circle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 35, height: 35)

                Circle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 28, height: 28)
                    .offset(x: 8, y: 5)
            }
            .rotationEffect(.degrees(animate ? -2 : 2))
            .animation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                value: animate
            )

            // Trunk
            Rectangle()
                .fill(Color.brown.opacity(0.8))
                .frame(width: 8, height: 20)
        }
        .onAppear {
            animate = true
        }
    }
}

struct AnimalsLayer: View {
    let animals: [String]

    let positions: [(x: CGFloat, y: CGFloat)] = [
        (0.7, 0.6),
        (0.25, 0.5),
        (0.8, 0.3),
        (0.45, 0.4),
        (0.6, 0.25)
    ]

    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(animals.enumerated()), id: \.offset) { index, animal in
                if index < positions.count {
                    AnimalView(emoji: animalEmoji(animal))
                        .offset(
                            x: positions[index].x * geometry.size.width,
                            y: positions[index].y * geometry.size.height
                        )
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    private func animalEmoji(_ animal: String) -> String {
        switch animal {
        case "butterfly": return "🦋"
        case "bird": return "🐦"
        case "rabbit": return "🐰"
        case "deer": return "🦌"
        case "fox": return "🦊"
        default: return "🐛"
        }
    }
}

struct AnimalView: View {
    let emoji: String
    @State private var offset: CGFloat = 0

    var body: some View {
        Text(emoji)
            .font(.system(size: 24))
            .offset(y: offset)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                ) {
                    offset = -5
                }
            }
    }
}

#Preview {
    GardenView(progress: Progress(
        totalPomodoros: 25,
        todayPomodoros: 5,
        currentStreak: 7,
        trees: 8,
        clouds: 5,
        animals: ["butterfly", "bird", "rabbit"],
        history: []
    ))
    .padding()
}
