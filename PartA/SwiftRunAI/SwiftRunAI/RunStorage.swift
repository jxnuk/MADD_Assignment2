import CoreData

class RunStorage {
    static let shared = RunStorage()
    
    private let context = PersistenceController.shared.container.viewContext
    
    func saveRun(stats: GameStats) {
        
        // Fetch last 10 runs
        let previousRuns = fetchRuns().prefix(10)
        
        // Compute averages
        let avgDistance = previousRuns.map(\.distance).averageOrZero
        let avgDuration = previousRuns.map(\.duration).averageOrZero
        let avgObstacles = previousRuns.map { Double($0.obstaclesHit) }.averageOrZero
        let avgCoins = previousRuns.map { Double($0.coinsCollected) }.averageOrZero
        
        // Predict using ML
        let prediction = MLManager.shared.predictSkillAndDistance(
            avgDistance: avgDistance,
            avgDuration: avgDuration,
            avgObstaclesHit: avgObstacles,
            avgCoinsCollected: avgCoins,
            runsCount: Double(previousRuns.count)
        )
        
        // Save to Core Data
        let run = Run(context: context)
        run.id = UUID()
        run.date = Date()
        run.distance = stats.distance
        run.duration = stats.duration
        run.coinsCollected = Int16(stats.score)
        run.obstaclesHit = Int16(stats.obstaclesHit)
        run.difficulty = "Normal"
        
        run.predictedSkill = prediction.skill
        run.predictedNextDistance = prediction.predictedDistance
        
        do {
            try context.save()
            print("✅ Run saved with ML predictions!")
        } catch {
            print("❌ Failed to save run:", error.localizedDescription)
        }
    }
    
    func fetchRuns() -> [Run] {
        let request = NSFetchRequest<Run>(entityName: "Run")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch error:", error.localizedDescription)
            return []
        }
    }
    
    func clearAllRuns() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(delete)
            try context.save()
            print("🗑️ Cleared run history")
        } catch {
            print("❌ Clear error:", error.localizedDescription)
        }
    }
}

extension Array where Element == Double {
    var averageOrZero: Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
