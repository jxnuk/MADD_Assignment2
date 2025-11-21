import CoreML

class MLManager {
    static let shared = MLManager()
    
    private let model: SwiftRunSkillPredictor
    
    private init() {
        let config = MLModelConfiguration()
        model = try! SwiftRunSkillPredictor(configuration: config)
    }
    
    func predictSkillAndDistance(
        avgDistance: Double,
        avgDuration: Double,
        avgObstaclesHit: Double,
        avgCoinsCollected: Double,
        runsCount: Double
    ) -> (skill: String, predictedDistance: Double) {
        
        do {
            let input = SwiftRunSkillPredictorInput(
                avgDistance: Int64(avgDistance),
                avgDuration: Int64(avgDuration),
                avgObstaclesHit: Int64(avgObstaclesHit),
                avgCoinsCollected: Int64(avgCoinsCollected),
                runsCount: Int64(runsCount)
            )
            
            let output = try model.prediction(input: input)
            
            // Model only gives us skillLevel
            let skill = output.skillLevel
            
            // Heuristic: suggest slightly better than average distance
            let predictedNextDistance = avgDistance > 0 ? avgDistance * 1.1 : 0
            
            return (skill: skill, predictedDistance: predictedNextDistance)
        } catch {
            print("⚠️ ML ERROR:", error.localizedDescription)
            return ("Unknown", 0)
        }
    }
}
