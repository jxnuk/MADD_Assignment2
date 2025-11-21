import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // MARK: - Preview Setup
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample Run objects for SwiftUI previews
        for i in 0..<5 {
            let run = Run(context: viewContext)
            run.id = UUID()
            run.date = Date().addingTimeInterval(Double(-i) * 86000)
            run.distance = Double.random(in: 200...1200)
            run.duration = Double.random(in: 20...120)
            run.coinsCollected = Int16.random(in: 0...20)
            run.obstaclesHit = Int16.random(in: 0...3)
            run.difficulty = ["Easy", "Medium", "Hard"].randomElement()!
            run.predictedSkill = ["Beginner", "Intermediate", "Advanced"].randomElement()
            run.predictedNextDistance = Double.random(in: 200...1500)
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved preview error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    // MARK: - Persistent Container
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftRunAI")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 */
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
