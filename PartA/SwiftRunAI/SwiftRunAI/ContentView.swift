import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        NavigationStack {
            MainMenuView()
        }
        .preferredColorScheme(appSettings.colorScheme)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSettings())
}
