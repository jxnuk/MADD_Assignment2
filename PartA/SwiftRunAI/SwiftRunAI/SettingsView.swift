import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    @State private var showClearConfirm = false
    @State private var showResetConfirm = false
    
    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $appSettings.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
            }
            
            Section("Gameplay") {
                Toggle("AI Adjusts Difficulty", isOn: $appSettings.aiAdjustsDifficulty)
                Toggle("Sound Effects", isOn: $appSettings.soundEffectsEnabled)
            }
            
            Section("Data") {
                Button(role: .destructive) {
                    showClearConfirm = true
                } label: {
                    Label("Clear Run History", systemImage: "trash")
                }
                
                Button {
                    showResetConfirm = true
                } label: {
                    Label("Reset Settings to Default", systemImage: "arrow.counterclockwise")
                }
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog(
            "Clear all saved run history?",
            isPresented: $showClearConfirm,
            titleVisibility: .visible
        ) {
            Button("Clear History", role: .destructive) {
                RunStorage.shared.clearAllRuns()
                haptic(.success)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all recorded runs. This cannot be undone.")
        }
        .alert("Reset all settings?", isPresented: $showResetConfirm) {
            Button("Reset", role: .destructive) {
                appSettings.resetToDefaults()
                haptic(.success)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Theme, AI difficulty and sound options will be restored to their default values.")
        }
    }
    
    // MARK: - Haptics
    
    private func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(AppSettings())
}
