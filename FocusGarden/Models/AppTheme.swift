//
//  AppTheme.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

enum AppTheme: String, CaseIterable, Codable {
    case system
    case dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .dark:
            return .dark
        }
    }
}
