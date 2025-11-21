import SwiftUI

struct RunSummaryView: View {
    let distance: Double
    let duration: Double
    let coins: Int
    let obstaclesHit: Int
    let predictedSkill: String?
    let predictedNextDistance: Double?
    
    var body: some View {
        VStack(spacing: 14) {
            Text("Run Summary")
                .font(.title.bold())
            
            summaryRow("Distance", "\(Int(distance)) m")
            summaryRow("Duration", "\(Int(duration)) s")
            summaryRow("Coins", "\(coins)")
            summaryRow("Obstacles Hit", "\(obstaclesHit)")
            
            if let skill = predictedSkill {
                summaryRow("AI Skill Level", skill)
            }
            
            if let predDist = predictedNextDistance {
                summaryRow("Predicted Next Run", "\(Int(predDist)) m")
            }
        }
        .padding()
        .frame(maxWidth: 340)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    private func summaryRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
}
