//
//  AppLanguage.swift
//  FocusGarden
//
//  Created by Claude
//

import Foundation

enum AppLanguage: String, CaseIterable, Codable {
    case english = "en"
    case russian = "ru"

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var displayName: String {
        switch self {
        case .english:
            return NSLocalizedString("language_english", comment: "English language option")
        case .russian:
            return NSLocalizedString("language_russian", comment: "Russian language option")
        }
    }
}
