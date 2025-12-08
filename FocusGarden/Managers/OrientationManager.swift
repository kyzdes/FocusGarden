//
//  OrientationManager.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI
import Combine
import UIKit

class OrientationManager: ObservableObject {
    @Published var isLandscape: Bool = false

    init() {
        updateOrientation()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    @objc private func orientationDidChange() {
        updateOrientation()
    }

    private func updateOrientation() {
        let orientation = UIDevice.current.orientation

        switch orientation {
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
        case .portrait, .portraitUpsideDown:
            isLandscape = false
        default:
            // Keep current state for unknown/faceUp/faceDown
            break
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
