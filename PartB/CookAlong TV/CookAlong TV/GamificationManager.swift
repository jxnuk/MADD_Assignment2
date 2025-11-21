import Foundation
import Combine

enum ChefRank: String, CaseIterable {
    case apprentice
    case lineCook
    case sousChef
    case headChef
    case masterChef
    case legendary

    var displayName: String {
        switch self {
        case .apprentice: return "Apprentice"
        case .lineCook: return "Line Cook"
        case .sousChef: return "Sous Chef"
        case .headChef: return "Head Chef"
        case .masterChef: return "Master Chef"
        case .legendary: return "Legendary Chef"
        }
    }

    static func rank(forXP xp: Int) -> ChefRank {
        switch xp {
        case ..<500: return .apprentice
        case 500..<1500: return .lineCook
        case 1500..<3000: return .sousChef
        case 3000..<6000: return .headChef
        case 6000..<10000: return .masterChef
        default: return .legendary
        }
    }

    var nextThreshold: Int? {
        switch self {
        case .apprentice: return 500
        case .lineCook: return 1500
        case .sousChef: return 3000
        case .headChef: return 6000
        case .masterChef: return 10000
        case .legendary: return nil
        }
    }
}

enum AchievementCriteria {
    case recipesCompleted(min: Int)
    case perfectTimers(min: Int)
    case categoryCompleted(category: RecipeCategory, min: Int)
    case advancedRecipes(min: Int)
}

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let criteria: AchievementCriteria
}

class GamificationManager: ObservableObject {
    @Published private(set) var totalXP: Int
    @Published private(set) var recipesCompleted: Int
    @Published private(set) var perfectTimers: Int
    @Published private(set) var advancedRecipes: Int
    @Published private(set) var categoryCounts: [String: Int]
    @Published private(set) var unlockedAchievementIDs: Set<String>

    private let xpKey = "gamification_totalXP"
    private let recipesCompletedKey = "gamification_recipesCompleted"
    private let perfectTimersKey = "gamification_perfectTimers"
    private let advancedRecipesKey = "gamification_advancedRecipes"
    private let categoryCountsKey = "gamification_categoryCounts"
    private let unlockedAchievementsKey = "gamification_unlockedAchievements"

    init() {
        let defaults = UserDefaults.standard
        self.totalXP = defaults.integer(forKey: xpKey)
        self.recipesCompleted = defaults.integer(forKey: recipesCompletedKey)
        self.perfectTimers = defaults.integer(forKey: perfectTimersKey)
        self.advancedRecipes = defaults.integer(forKey: advancedRecipesKey)
        self.categoryCounts = defaults.dictionary(forKey: categoryCountsKey) as? [String: Int] ?? [:]
        if let stored = defaults.array(forKey: unlockedAchievementsKey) as? [String] {
            self.unlockedAchievementIDs = Set(stored)
        } else {
            self.unlockedAchievementIDs = []
        }
    }

    var currentRank: ChefRank {
        ChefRank.rank(forXP: totalXP)
    }

    var xpToNextRank: Int? {
        guard let next = currentRank.nextThreshold else { return nil }
        return max(0, next - totalXP)
    }

    // All defined achievements (A, C, D)
    var allAchievements: [Achievement] {
        [
            Achievement(
                id: "first_dish",
                name: "First Dish!",
                description: "Complete your first recipe.",
                icon: "🥄",
                criteria: .recipesCompleted(min: 1)
            ),
            Achievement(
                id: "steady_chef",
                name: "Steady Chef",
                description: "Complete 10 recipes.",
                icon: "🍳",
                criteria: .recipesCompleted(min: 10)
            ),
            Achievement(
                id: "pro_chef",
                name: "Pro Chef",
                description: "Complete 20 recipes.",
                icon: "👨‍🍳",
                criteria: .recipesCompleted(min: 20)
            ),
            Achievement(
                id: "perfect_timing_1",
                name: "Perfect Timing I",
                description: "Get 3 perfect timers.",
                icon: "⏱️",
                criteria: .perfectTimers(min: 3)
            ),
            Achievement(
                id: "perfect_timing_2",
                name: "Perfect Timing II",
                description: "Get 10 perfect timers.",
                icon: "⏲️",
                criteria: .perfectTimers(min: 10)
            ),
            Achievement(
                id: "pasta_lover",
                name: "Pasta Lover",
                description: "Complete 3 pasta recipes.",
                icon: "🍝",
                criteria: .categoryCompleted(category: .pasta, min: 3)
            ),
            Achievement(
                id: "breakfast_champ",
                name: "Breakfast Champion",
                description: "Complete 3 breakfast recipes.",
                icon: "🥐",
                criteria: .categoryCompleted(category: .breakfast, min: 3)
            ),
            Achievement(
                id: "dessert_fan",
                name: "Dessert Fan",
                description: "Complete 3 dessert recipes.",
                icon: "🍰",
                criteria: .categoryCompleted(category: .dessert, min: 3)
            ),
            Achievement(
                id: "advanced_cook",
                name: "Advanced Chef",
                description: "Complete 5 advanced recipes.",
                icon: "🔥",
                criteria: .advancedRecipes(min: 5)
            )
        ]
    }

    var unlockedAchievements: [Achievement] {
        allAchievements.filter { unlockedAchievementIDs.contains($0.id) }
    }

    func notifyRecipeCompleted(recipe: Recipe, usedTimer: Bool, perfectTimer: Bool) {
        recipesCompleted += 1

        if perfectTimer {
            perfectTimers += 1
        }

        if recipe.difficulty == .advanced {
            advancedRecipes += 1
        }

        let categoryKey = recipe.category.rawValue
        categoryCounts[categoryKey, default: 0] += 1

        let xpFromRecipe = Int(Double(recipe.baseXP) * recipe.difficulty.xpMultiplier)
        let timerBonus = perfectTimer ? 30 : (usedTimer ? 10 : 0)
        addXP(xpFromRecipe + timerBonus)

        saveState()
        evaluateAchievements()
    }

    private func addXP(_ amount: Int) {
        totalXP += amount
        saveState()
    }

    private func evaluateAchievements() {
        var newlyUnlocked: [String] = []

        for achievement in allAchievements {
            guard !unlockedAchievementIDs.contains(achievement.id) else { continue }
            if check(criteria: achievement.criteria) {
                unlockedAchievementIDs.insert(achievement.id)
                newlyUnlocked.append(achievement.id)
            }
        }

        if !newlyUnlocked.isEmpty {
            saveState()
        }
    }

    private func check(criteria: AchievementCriteria) -> Bool {
        switch criteria {
        case .recipesCompleted(min: let min):
            return recipesCompleted >= min
        case .perfectTimers(min: let min):
            return perfectTimers >= min
        case .categoryCompleted(category: let cat, min: let min):
            let count = categoryCounts[cat.rawValue] ?? 0
            return count >= min
        case .advancedRecipes(min: let min):
            return advancedRecipes >= min
        }
    }

    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(totalXP, forKey: xpKey)
        defaults.set(recipesCompleted, forKey: recipesCompletedKey)
        defaults.set(perfectTimers, forKey: perfectTimersKey)
        defaults.set(advancedRecipes, forKey: advancedRecipesKey)
        defaults.set(categoryCounts, forKey: categoryCountsKey)
        defaults.set(Array(unlockedAchievementIDs), forKey: unlockedAchievementsKey)
    }
}
