//
//  SoundManager.swift
//  FocusGarden
//
//  Created by Claude
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func playCompletionSound() {
        // Use system sound for completion
        let systemSoundID: SystemSoundID = 1057 // Tink sound
        AudioServicesPlaySystemSound(systemSoundID)

        // Also trigger haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func playTickSound() {
        let systemSoundID: SystemSoundID = 1104 // Tock sound
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
