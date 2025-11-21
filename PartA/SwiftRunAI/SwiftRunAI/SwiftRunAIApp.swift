import SwiftUI
import CoreData

@main
struct SwiftRunAIApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appSettings)
        }
    }
}
