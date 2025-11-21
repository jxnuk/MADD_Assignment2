import SwiftUI
import Combine

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

class AppSettings: ObservableObject {
    @Published var aiAdjustsDifficulty: Bool {
        didSet { save() }
    }
    @Published var soundEffectsEnabled: Bool {
        didSet { save() }
    }
    @Published var theme: AppTheme {
        didSet { save() }
    }
    
    init() {
        let defaults = UserDefaults.standard
        
        if let themeRaw = defaults.string(forKey: "appTheme"),
           let storedTheme = AppTheme(rawValue: themeRaw) {
            theme = storedTheme
        } else {
            theme = .dark
        }
        
        aiAdjustsDifficulty = defaults.object(forKey: "aiAdjustsDifficulty") as? Bool ?? true
        soundEffectsEnabled = defaults.object(forKey: "soundEffectsEnabled") as? Bool ?? true
    }
    
    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(theme.rawValue, forKey: "appTheme")
        defaults.set(aiAdjustsDifficulty, forKey: "aiAdjustsDifficulty")
        defaults.set(soundEffectsEnabled, forKey: "soundEffectsEnabled")
    }
    
    func resetToDefaults() {
        theme = .dark
        aiAdjustsDifficulty = true
        soundEffectsEnabled = true
    }
    
    var colorScheme: ColorScheme? {
        switch theme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
