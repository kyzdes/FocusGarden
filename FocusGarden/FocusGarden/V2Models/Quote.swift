//
//  Quote.swift
//  FocusGarden v2.0
//
//  Created by Claude
//

import Foundation

enum QuoteCategory: String, Codable, CaseIterable {
    case productivity = "Productivity"
    case success = "Success"
    case perseverance = "Perseverance"
    case focus = "Focus"
    case creativity = "Creativity"
    case wellness = "Wellness"

    var icon: String {
        switch self {
        case .productivity: return "⚡"
        case .success: return "🏆"
        case .perseverance: return "💪"
        case .focus: return "🎯"
        case .creativity: return "🎨"
        case .wellness: return "🧘"
        }
    }
}

struct Quote: Codable, Identifiable, Equatable {
    let id: UUID
    let text: String
    let author: String
    let category: QuoteCategory
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        text: String,
        author: String,
        category: QuoteCategory,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.text = text
        self.author = author
        self.category = category
        self.isFavorite = isFavorite
    }
}

extension Quote {
    static let quotes: [Quote] = [
        // Productivity
        Quote(text: "The secret of getting ahead is getting started.", author: "Mark Twain", category: .productivity),
        Quote(text: "Focus on being productive instead of busy.", author: "Tim Ferriss", category: .productivity),
        Quote(text: "It's not always that we need to do more but rather that we need to focus on less.", author: "Nathan W. Morris", category: .productivity),
        Quote(text: "Productivity is never an accident. It is always the result of a commitment to excellence.", author: "Paul J. Meyer", category: .productivity),
        Quote(text: "Until we can manage time, we can manage nothing else.", author: "Peter Drucker", category: .productivity),

        // Success
        Quote(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", category: .success),
        Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: .success),
        Quote(text: "Success usually comes to those who are too busy to be looking for it.", author: "Henry David Thoreau", category: .success),
        Quote(text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson", category: .success),

        // Perseverance
        Quote(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius", category: .perseverance),
        Quote(text: "Fall seven times, stand up eight.", author: "Japanese Proverb", category: .perseverance),
        Quote(text: "The only impossible journey is the one you never begin.", author: "Tony Robbins", category: .perseverance),
        Quote(text: "Perseverance is not a long race; it is many short races one after the other.", author: "Walter Elliot", category: .perseverance),

        // Focus
        Quote(text: "Concentrate all your thoughts upon the work in hand. The sun's rays do not burn until brought to a focus.", author: "Alexander Graham Bell", category: .focus),
        Quote(text: "The successful warrior is the average man, with laser-like focus.", author: "Bruce Lee", category: .focus),
        Quote(text: "Where focus goes, energy flows.", author: "Tony Robbins", category: .focus),
        Quote(text: "Lack of direction, not lack of time, is the problem. We all have twenty-four hour days.", author: "Zig Ziglar", category: .focus),

        // Creativity
        Quote(text: "Creativity is intelligence having fun.", author: "Albert Einstein", category: .creativity),
        Quote(text: "The desire to create is one of the deepest yearnings of the human soul.", author: "Dieter F. Uchtdorf", category: .creativity),
        Quote(text: "Creativity takes courage.", author: "Henri Matisse", category: .creativity),

        // Wellness
        Quote(text: "Take care of your body. It's the only place you have to live.", author: "Jim Rohn", category: .wellness),
        Quote(text: "An hour of effective, intense work is worth weeks of half-hearted effort.", author: "Unknown", category: .wellness),
        Quote(text: "Rest when you're weary. Refresh and renew yourself, your body, your mind, your spirit. Then get back to work.", author: "Ralph Marston", category: .wellness),
        Quote(text: "Almost everything will work again if you unplug it for a few minutes, including you.", author: "Anne Lamott", category: .wellness),
    ]

    static func randomQuote() -> Quote {
        quotes.randomElement() ?? quotes[0]
    }

    static func quoteForCategory(_ category: QuoteCategory) -> Quote {
        let filtered = quotes.filter { $0.category == category }
        return filtered.randomElement() ?? quotes[0]
    }
}
