//
//  GardenTheme.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import SwiftUI

enum GardenTheme: String, Codable, CaseIterable, Identifiable {
    case zenGarden = "Zen Garden"
    case desertOasis = "Desert Oasis"
    case tropicalParadise = "Tropical Paradise"
    case enchantedForest = "Enchanted Forest"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .zenGarden: return "🌸"
        case .desertOasis: return "🌵"
        case .tropicalParadise: return "🌴"
        case .enchantedForest: return "🌲"
        }
    }

    var description: String {
        switch self {
        case .zenGarden:
            return "Peaceful Japanese garden with cherry blossoms and koi pond"
        case .desertOasis:
            return "Warm desert oasis with cacti and palm trees"
        case .tropicalParadise:
            return "Vibrant tropical paradise with exotic flowers and waterfalls"
        case .enchantedForest:
            return "Mystical forest with glowing fireflies and ancient trees"
        }
    }

    var unlockRequirement: Int {
        switch self {
        case .zenGarden: return 0  // Free
        case .desertOasis: return 25
        case .tropicalParadise: return 50
        case .enchantedForest: return 100
        }
    }

    var skyColors: (top: Color, bottom: Color) {
        switch self {
        case .zenGarden:
            return (Color(red: 0.89, green: 0.95, blue: 0.97),
                   Color(red: 0.82, green: 0.91, blue: 0.94))
        case .desertOasis:
            return (Color(red: 1.0, green: 0.85, blue: 0.6),
                   Color(red: 0.95, green: 0.75, blue: 0.5))
        case .tropicalParadise:
            return (Color(red: 0.4, green: 0.8, blue: 1.0),
                   Color(red: 0.5, green: 0.9, blue: 1.0))
        case .enchantedForest:
            return (Color(red: 0.3, green: 0.2, blue: 0.4),
                   Color(red: 0.4, green: 0.3, blue: 0.5))
        }
    }

    var groundColors: (top: Color, bottom: Color) {
        switch self {
        case .zenGarden:
            return (Color(red: 0.78, green: 0.90, blue: 0.79),
                   Color(red: 0.85, green: 0.95, blue: 0.86))
        case .desertOasis:
            return (Color(red: 0.95, green: 0.85, blue: 0.65),
                   Color(red: 0.90, green: 0.80, blue: 0.60))
        case .tropicalParadise:
            return (Color(red: 0.2, green: 0.7, blue: 0.3),
                   Color(red: 0.3, green: 0.8, blue: 0.4))
        case .enchantedForest:
            return (Color(red: 0.2, green: 0.3, blue: 0.2),
                   Color(red: 0.3, green: 0.4, blue: 0.3))
        }
    }

    var trees: [String] {
        switch self {
        case .zenGarden:
            return ["🌸", "🍁", "🌳"]
        case .desertOasis:
            return ["🌵", "🌴", "🌿"]
        case .tropicalParadise:
            return ["🌴", "🌺", "🌻"]
        case .enchantedForest:
            return ["🌲", "🍄", "🌰"]
        }
    }

    var animals: [String] {
        switch self {
        case .zenGarden:
            return ["🦋", "🐦", "🐟"]
        case .desertOasis:
            return ["🦎", "🐪", "🦅"]
        case .tropicalParadise:
            return ["🦜", "🦋", "🐠"]
        case .enchantedForest:
            return ["🦉", "🦔", "🧚"]
        }
    }
}
