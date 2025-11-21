import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("How To Play")
                    .font(.largeTitle.bold())
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Run automatically forward", systemImage: "figure.run")
                        Label("Tap Jump button to jump", systemImage: "arrowshape.up.fill")
                        Label("Tap Shoot button to fire projectiles", systemImage: "scope")
                        Label("Avoid or destroy enemies", systemImage: "skull.fill")
                        Label("Collect coins to score points", systemImage: "bitcoinsign.circle")
                        Label("Boss appears at higher distance", systemImage: "flame.fill")
                    }
                    .padding()
                }
                
                GroupBox(label: Text("Tips").font(.headline)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Jump earlier to avoid taller enemies.")
                        Text("• Shoot obstacles to gain extra points.")
                        Text("• Bosses take multiple hits.")
                        Text("• Play more to unlock AI predictions.")
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationTitle("How To Play")
    }
}

#Preview {
    NavigationStack { HowToPlayView() }
}
