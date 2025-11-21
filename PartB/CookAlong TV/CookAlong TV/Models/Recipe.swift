import Foundation

enum RecipeCategory: String, CaseIterable, Identifiable, Codable {
    case pasta
    case chicken
    case beef
    case breakfast
    case rice
    case soup
    case eggs
    case sandwich
    case vegetarian
    case dessert

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pasta: return "Pasta"
        case .chicken: return "Chicken"
        case .beef: return "Beef"
        case .breakfast: return "Breakfast"
        case .rice: return "Rice"
        case .soup: return "Soup"
        case .eggs: return "Eggs"
        case .sandwich: return "Sandwich"
        case .vegetarian: return "Vegetarian"
        case .dessert: return "Dessert"
        }
    }
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner
    case intermediate
    case advanced

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }

    var xpMultiplier: Double {
        switch self {
        case .beginner: return 1.0
        case .intermediate: return 1.5
        case .advanced: return 2.0
        }
    }
}

struct RecipeStep: Identifiable {
    let id = UUID()
    let text: String
    /// Duration in seconds, if this step supports a timer
    let duration: Int?
}

struct Recipe: Identifiable {
    let id: String
    let name: String
    let image: String
    let category: RecipeCategory
    let difficulty: DifficultyLevel
    let baseXP: Int
    let steps: [RecipeStep]
}
