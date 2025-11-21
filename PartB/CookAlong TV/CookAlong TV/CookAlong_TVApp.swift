import SwiftUI
import Combine
import CoreData

@main
struct CookAlongTVApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var gamificationManager = GamificationManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gamificationManager)
        }
    }
}
