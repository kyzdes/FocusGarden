//
//  AmbientSound.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum SoundCategory: String, Codable, CaseIterable {
    case nature = "Nature"
    case ambience = "Ambience"
    case music = "Music"
    case white = "White Noise"

    var icon: String {
        switch self {
        case .nature: return "🌲"
        case .ambience: return "☕"
        case .music: return "🎵"
        case .white: return "🌊"
        }
    }
}

struct AmbientSound: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let category: SoundCategory
    let icon: String
    let fileName: String? // For actual audio files when available
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: SoundCategory,
        icon: String,
        fileName: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.icon = icon
        self.fileName = fileName
        self.isFavorite = isFavorite
    }
}

extension AmbientSound {
    static let sounds: [AmbientSound] = [
        // Nature
        AmbientSound(name: "Light Rain", category: .nature, icon: "🌧️", fileName: "light_rain"),
        AmbientSound(name: "Heavy Rain", category: .nature, icon: "⛈️", fileName: "heavy_rain"),
        AmbientSound(name: "Thunderstorm", category: .nature, icon: "⚡", fileName: "thunderstorm"),
        AmbientSound(name: "Ocean Waves", category: .nature, icon: "🌊", fileName: "ocean_waves"),
        AmbientSound(name: "Forest Sounds", category: .nature, icon: "🌲", fileName: "forest"),
        AmbientSound(name: "Flowing Water", category: .nature, icon: "💧", fileName: "flowing_water"),
        AmbientSound(name: "Birds Chirping", category: .nature, icon: "🐦", fileName: "birds"),

        // Ambience
        AmbientSound(name: "Coffee Shop", category: .ambience, icon: "☕", fileName: "coffee_shop"),
        AmbientSound(name: "Crackling Fire", category: .ambience, icon: "🔥", fileName: "fireplace"),
        AmbientSound(name: "Library", category: .ambience, icon: "📚", fileName: "library"),

        // Music
        AmbientSound(name: "Piano Ambient", category: .music, icon: "🎹", fileName: "piano_ambient"),
        AmbientSound(name: "Lo-fi Beats", category: .music, icon: "🎸", fileName: "lofi"),
        AmbientSound(name: "Classical", category: .music, icon: "🎼", fileName: "classical"),

        // White Noise
        AmbientSound(name: "White Noise", category: .white, icon: "🌌", fileName: "white_noise"),
        AmbientSound(name: "Brown Noise", category: .white, icon: "🔊", fileName: "brown_noise"),
        AmbientSound(name: "Pink Noise", category: .white, icon: "🎚️", fileName: "pink_noise"),
    ]
}

struct SoundMix: Codable {
    var sounds: [UUID: Float] // Sound ID to volume (0-1)
    var masterVolume: Float

    init(sounds: [UUID: Float] = [:], masterVolume: Float = 0.7) {
        self.sounds = sounds
        self.masterVolume = masterVolume
    }
}
