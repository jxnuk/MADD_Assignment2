struct GameStats {
    var score: Int
    var distance: Double
    var obstaclesHit: Int
    var duration: Double
    
    // ML Fields (optional)
    var predictedSkill: String?
    var predictedNextDistance: Double?
}
