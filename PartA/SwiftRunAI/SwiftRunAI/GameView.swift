import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var scene: GameScene? = nil
    
    @State private var score = 0
    @State private var distance = 0.0
    @State private var health = 3
    
    // Summary data
    @State private var summaryDistance: Double = 0
    @State private var summaryDuration: Double = 0
    @State private var summaryCoins: Int = 0
    @State private var summaryObstacles: Int = 0
    @State private var summaryPredictedSkill: String? = nil
    @State private var summaryPredictedNextDistance: Double? = nil
    
    @State private var showSummary = false
    @State private var isPaused = false
    
    // MARK: - Scene setup
    
    private func createNewScene() {
        let newScene = GameScene(size: CGSize(width: 1920, height: 1080))
        newScene.scaleMode = .resizeFill
        
        // Live HUD callbacks
        newScene.onScoreUpdate = { newScore in
            DispatchQueue.main.async { score = newScore }
        }
        
        newScene.onDistanceUpdate = { newDist in
            DispatchQueue.main.async { distance = newDist }
        }
        
        newScene.onHealthUpdate = { newHealth in
            DispatchQueue.main.async { health = newHealth }
        }
        
        // End-of-run callback
        newScene.onGameEndWithStats = { stats in
            DispatchQueue.main.async {
                // 1) Save run (RunStorage will call MLManager internally)
                RunStorage.shared.saveRun(stats: stats)
                
                // 2) Fetch latest run to read predictions
                let latestRun = RunStorage.shared.fetchRuns().first
                
                summaryDistance = stats.distance
                summaryDuration = stats.duration
                summaryCoins = stats.score
                summaryObstacles = stats.obstaclesHit
                summaryPredictedSkill = latestRun?.predictedSkill
                summaryPredictedNextDistance = latestRun?.predictedNextDistance
                
                showSummary = true
                isPaused = true
                newScene.isPaused = true
            }
        }
        
        scene = newScene
    }
    
    // MARK: - Difficulty label
    
    private func difficultyLabel(for distance: Double) -> String {
        switch distance {
        case 0..<400:
            return "Easy"
        case 400..<900:
            return "Medium"
        default:
            return "Hard"
        }
    }
    
    // MARK: - HUD pieces
    
    private var topHUD: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Score: \(score)")
                    .font(.title3.bold())
                Text("Distance: \(Int(distance)) m")
                    .font(.subheadline)
                Text("Difficulty: \(difficultyLabel(for: distance))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("\(health)")
                        .font(.headline)
                }
                
                Button {
                    guard let scene = scene, !showSummary else { return }
                    isPaused.toggle()
                    scene.isPaused = isPaused
                } label: {
                    Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(.black.opacity(0.4))
                        .clipShape(Circle())
                }
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }
    
    private func controlButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(color.opacity(0.7))
                .frame(width: 80, height: 80)
                .shadow(radius: 8)
                .overlay(
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
        }
    }
    
    private var controlsOverlay: some View {
        VStack {
            Spacer()
            HStack {
                controlButton(icon: "scope", color: .blue) {
                    scene?.fireProjectile()
                }
                .padding(.leading, 40)
                
                Spacer()
                
                controlButton(icon: "arrow.up.circle.fill", color: .green) {
                    scene?.playerJump()
                }
                .padding(.trailing, 40)
            }
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            VStack {
                topHUD
                Spacer()
            }
            
            controlsOverlay
            
            // Pause Overlay
            if isPaused && !showSummary {
                VStack(spacing: 20) {
                    Text("Paused")
                        .font(.largeTitle.bold())
                    
                    Button("Resume") {
                        if let scene = scene {
                            isPaused = false
                            scene.isPaused = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Quit to Menu") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
            }
            
            // Summary Overlay with ML predictions
            if showSummary {
                VStack(spacing: 20) {
                    RunSummaryView(
                        distance: summaryDistance,
                        duration: summaryDuration,
                        coins: summaryCoins,
                        obstaclesHit: summaryObstacles,
                        predictedSkill: summaryPredictedSkill,
                        predictedNextDistance: summaryPredictedNextDistance
                    )
                    
                    Button("Return to Menu") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
            }
        }
        .onAppear {
            // reset local state
            score = 0
            distance = 0
            health = 3
            showSummary = false
            isPaused = false
            summaryPredictedSkill = nil
            summaryPredictedNextDistance = nil
            
            createNewScene()
        }
        .onDisappear {
            scene?.isPaused = true
            scene = nil
        }
    }
}

#Preview {
    GameView()
}
